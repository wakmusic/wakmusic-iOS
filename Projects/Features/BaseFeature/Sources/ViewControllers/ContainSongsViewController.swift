import BaseDomainInterface
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import NVActivityIndicatorView
import PlaylistDomainInterface
import RxSwift
import UIKit
import UserDomainInterface
import Utility

public final class ContainSongsViewController: BaseViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    let containerView = UIView(frame: CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: 48))
    let songCountLabel: UILabel = UILabel()
    let subTitleLabel: UILabel = UILabel()
    var multiPurposePopupFactory: MultiPurposePopupFactory!
    var textPopupFactory: TextPopupFactory!

    var viewModel: ContainSongsViewModel!
    lazy var input = ContainSongsViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
        inputBind()
        outputBind()
        input.viewDidLoad.onNext(())
    }

    public static func viewController(
        multiPurposePopupFactory: MultiPurposePopupFactory,
        textPopupFactory: TextPopupFactory,
        viewModel: ContainSongsViewModel
    ) -> ContainSongsViewController {
        let viewController = ContainSongsViewController.viewController(
            storyBoardName: "Base",
            bundle: Bundle.module
        )
        viewController.multiPurposePopupFactory = multiPurposePopupFactory
        viewController.textPopupFactory = textPopupFactory
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ContainSongsViewController {
    private func addSubviews() {
        containerView.addSubviews(songCountLabel, subTitleLabel)
        tableView.tableHeaderView = containerView
    }

    private func setLayout() {
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(songCountLabel.snp.trailing)
            $0.centerY.equalTo(songCountLabel.snp.centerY)
        }

        songCountLabel.snp.makeConstraints {
            $0.leading.equalTo(closeButton.snp.leading)
            $0.centerY.equalToSuperview()
        }
    }

    private func inputBind() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .do(onNext: { [weak self] indexPath, _ in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .map { indexPath, model -> PlaylistEntity in
                return model[indexPath.row]
            }
            .bind(to: input.itemDidTap)
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(.shouldRefreshPlaylist)
            .map { _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)
    }

    private func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                guard let self = self else {
                    return
                }
                let space = APP_HEIGHT() - 48 - 16 - 24 - 12 - 52 - 12 - STATUS_BAR_HEGHIT() - SAFEAREA_BOTTOM_HEIGHT()
                let height = space / 3 * 2

                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                warningView.text = "내 리스트가 없습니다."
                self.tableView.tableFooterView = model.isEmpty ? warningView : nil
                self.indicator.stopAnimating()
            })
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "CurrentPlaylistTableViewCell",
                    for: IndexPath(row: index, section: 0)
                ) as? CurrentPlaylistTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)

        output.showToastMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.showToast(text: result.description, options: [.tabBar])

                if result.status == 201 {
                    NotificationCenter.default.post(name: .shouldRefreshPlaylist, object: nil) // 플리목록창 이름 변경하기 위함
                } else if result.status == 200 {
                    NotificationCenter.default.post(name: .shouldRefreshPlaylist, object: nil) // 플리목록창 이름 변경하기 위함
                    self.dismiss(animated: true)
                } else if result.status == -1 {
                    return
                } else {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)

        output.onLogout
            .bind(with: self) { owner, error in
                owner.showToast(text: error.localizedDescription, options: [.tabBar])
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        output.showPricePopup
            .withLatestFrom(PreferenceManager.shared.$userInfo) { $1 }
            .compactMap { $0 }
            .withLatestFrom(output.creationPrice) { ($0, $1) }
            .bind(with: self) { owner, info in

                let (user, price) = (info.0, info.1)

                if user.itemCount < price {
                    owner.showToast(text: LocalizationStrings.lackOfMoney(price - user.itemCount), options: [.tabBar])
                    return
                }

                let text = owner.textPopupFactory.makeView(
                    text: "리스트를 만들기 위해서는\n음표 열매 \(price)개가 필요합니다.",
                    cancelButtonIsHidden: false,
                    confirmButtonText: "\(price)개 사용",
                    cancelButtonText: "취소",
                    completion: {
                        owner.input.payButtonDidTap.onNext(())
                    }, cancelCompletion: nil
                )

                owner.showBottomSheet(content: text)
            }
            .disposed(by: disposeBag)

        output.showCreationPopup
            .bind(with: self) { owner, _ in
                let multiPurposePopupVc = owner.multiPurposePopupFactory.makeView(
                    type: .creation,
                    key: "",
                    completion: { text in
                        owner.input.createPlaylist.onNext(text)
                    }
                )
                owner.showBottomSheet(content: multiPurposePopupVc, size: .fixed(296))
            }
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        closeButton.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)

        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        titleLabel.text = "리스트에 담기"
        titleLabel.setTextWithAttributes(kernValue: -0.5)

        // 24 , 12
        songCountLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        songCountLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
        songCountLabel.text = "\(viewModel.songs.count)"
        songCountLabel.setTextWithAttributes(kernValue: -0.5)

        subTitleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        subTitleLabel.textColor = DesignSystemAsset.PrimaryColor.sub3.color
        subTitleLabel.text = "곡 선택"
        subTitleLabel.setTextWithAttributes(kernValue: -0.5)

        indicator.type = .circleStrokeSpin
        indicator.color = DesignSystemAsset.PrimaryColor.point.color
        indicator.startAnimating()
    }
}

extension ContainSongsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ContainPlaylistHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))
        header.delegate = self
        return header
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
}

extension ContainSongsViewController: ContainPlaylistHeaderViewDelegate {
    public func action() {
        LogManager.analytics(ContainSongsAnalyticsLog.clickCreatePlaylistButton(location: .addMusics))
        input.creationButtonDidTap.onNext(())
    }
}
