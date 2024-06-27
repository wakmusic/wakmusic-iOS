import BaseDomainInterface
import BaseFeatureInterface
import DesignSystem
import NVActivityIndicatorView
import PlaylistDomainInterface
import RxSwift
import UIKit
import Utility

public protocol ContainSongsViewDelegate: AnyObject {
    func tokenExpired()
}

public final class ContainSongsViewController: BaseViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var songCountLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    var multiPurposePopUpFactory: MultiPurposePopUpFactory!

    var viewModel: ContainSongsViewModel!
    lazy var input = ContainSongsViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()
    public var delegate: ContainSongsViewDelegate?

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }

    public static func viewController(
        multiPurposePopUpFactory: MultiPurposePopUpFactory,
        viewModel: ContainSongsViewModel
    ) -> ContainSongsViewController {
        let viewController = ContainSongsViewController.viewController(
            storyBoardName: "Base",
            bundle: Bundle.module
        )
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ContainSongsViewController {
    private func bindRx() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        .disposed(by: disposeBag)

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
                    withIdentifier: "CurrentPlayListTableViewCell",
                    for: IndexPath(row: index, section: 0)
                ) as? CurrentPlayListTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .do(onNext: { [weak self] indexPath, _ in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .map { indexPath, model -> String in
                return model[indexPath.row].key
            }
            .bind(to: input.containSongWithKey)
            .disposed(by: disposeBag)

        output.showToastMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.showToast(text: result.description, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))

                NotificationCenter.default.post(name: .playListRefresh, object: nil) // 플리목록창 이름 변경하기 위함
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        output.onLogout
            .bind(with: self) { owner, error in
                let toastFont = DesignSystemFontFamily.Pretendard.light.font(size: 14)
                owner.showToast(text: error.localizedDescription, font: toastFont)
                NotificationCenter.default.post(name: .movedTab, object: 4)

                owner.dismiss(animated: true) {
                    owner.delegate?.tokenExpired()
                }
            }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(.playListRefresh)
            .map { _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        closeButton.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)

        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleLabel.text = "리스트에 담기"
        titleLabel.setTextWithAttributes(kernValue: -0.5)

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
        let header = ContainPlayListHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))
        header.delegate = self
        return header
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
}

extension ContainSongsViewController: ContainPlayListHeaderViewDelegate {
    public func action() {
        guard let multiPurposePopVc = multiPurposePopUpFactory.makeView(
            type: .creation,
            key: "",
            completion: nil
        ) as? MultiPurposePopupViewController else {
            return
        }
        self.showEntryKitModal(content: multiPurposePopVc, height: 296)
    }
}
#warning("토근 만료 처리")
//extension ContainSongsViewController: MultiPurposePopupViewDelegate {
//    public func didTokenExpired() {
//        self.dismiss(animated: true) { [weak self] in
//
//            guard let self else { return }
//
//            self.delegate?.tokenExpired()
//        }
//    }
//}
