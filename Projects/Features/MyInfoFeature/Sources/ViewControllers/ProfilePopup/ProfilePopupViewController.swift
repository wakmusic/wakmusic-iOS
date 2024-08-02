import DesignSystem
import ImageDomainInterface
import LogManager
import MyInfoFeatureInterface
import NVActivityIndicatorView
import RxCocoa
import RxRelay
import RxSwift
import UIKit
import Utility

public final class ProfilePopupViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dataLoadActivityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    private var completion: (() -> Void)?
    private var viewModel: ProfilePopupViewModel!
    private lazy var input = ProfilePopupViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    static let rowHeight: CGFloat = (APP_WIDTH() - 70) / 4

    deinit {
        LogManager.printDebug("\(Self.self) deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
    }

    public static func viewController(
        viewModel: ProfilePopupViewModel,
        completion: (() -> Void)? = nil
    ) -> UIViewController {
        let viewController = ProfilePopupViewController.viewController(
            storyBoardName: "ProfilePopUp",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        viewController.completion = completion
        return viewController
    }
}

private extension ProfilePopupViewController {
    func inputBind() {
        input.fetchProfileList.onNext(())

        collectionView.rx.itemSelected
            .bind(to: input.itemSelected)
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .throttle(.milliseconds(1000), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(output.dataSource)
            .map { model in
                let id: String = model.filter { $0.isSelected }.first?.name ?? ""
                return id
            }
            .filter { [weak self] id in
                guard !id.isEmpty else {
                    self?.output.showToast.onNext("프로필을 선택해주세요.")
                    return false
                }
                return true
            }
            .bind(with: self) { owner, _ in
                owner.activityIndicator.startAnimating()
                owner.saveButton.setAttributedTitle(
                    NSMutableAttributedString(
                        string: "",
                        attributes: [
                            .font: UIFont.WMFontSystem.t4(weight: .medium).font,
                            .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray25.color,
                            .kern: -0.5
                        ]
                    ), for: .normal
                )
                owner.input.requestSetProfile.onNext(())
            }
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [dataLoadActivityIndicator] _ in
                dataLoadActivityIndicator?.stopAnimating()
            })
            .bind(to: collectionView.rx.items) { collectionView, index, model -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ProfileCollectionViewCell",
                    for: IndexPath(row: index, section: 0)
                ) as? ProfileCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.update(model)
                return cell
            }
            .disposed(by: disposeBag)

        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(text: message, options: [.tabBar])
                owner.saveButton.setAttributedTitle(
                    NSMutableAttributedString(
                        string: "완료",
                        attributes: [
                            .font: UIFont.WMFontSystem.t4(weight: .medium).font,
                            .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray25.color,
                            .kern: -0.5
                        ]
                    ), for: .normal
                )
                owner.activityIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)

        output.completedProfile
            .bind(with: self) { owner, _ in
                owner.completion?()
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension ProfilePopupViewController {
    func configureUI() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.clipsToBounds = false
        collectionViewHeightConstraint.constant = (ProfilePopupViewController.rowHeight * 2) + 10

        titleLabel.text = "프로필을 선택해주세요"
        titleLabel.font = UIFont.WMFontSystem.t4(weight: .medium).font
        titleLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        titleLabel.setTextWithAttributes(kernValue: -0.5)

        saveButton.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.setAttributedTitle(
            NSMutableAttributedString(
                string: "완료",
                attributes: [
                    .font: UIFont.WMFontSystem.t4(weight: .medium).font,
                    .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray25.color,
                    .kern: -0.5
                ]
            ), for: .normal
        )

        dataLoadActivityIndicator.type = .circleStrokeSpin
        dataLoadActivityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        dataLoadActivityIndicator.startAnimating()

        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = .white
    }
}

extension ProfilePopupViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size: CGFloat = ProfilePopupViewController.rowHeight
        return CGSize(width: size, height: size)
    }

    /// 행간 간격
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }

    /// 아이템 사이 간격(좌,우)
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
}
