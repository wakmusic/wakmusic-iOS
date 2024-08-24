import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Kingfisher
import MyInfoFeatureInterface
import RxCocoa
import RxSwift
import UIKit
import Utility

public class ServiceInfoViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var openSourceLicenseFactory: OpenSourceLicenseFactory!
    var textPopupFactory: TextPopupFactory!
    var viewModel: ServiceInfoViewModel!
    var disposeBag: DisposeBag = DisposeBag()

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindBtn()
        inputBind()
        outputBind()
    }

    public static func viewController(
        viewModel: ServiceInfoViewModel,
        openSourceLicenseFactory: OpenSourceLicenseFactory,
        textPopupFactory: TextPopupFactory
    ) -> ServiceInfoViewController {
        let viewController = ServiceInfoViewController.viewController(
            storyBoardName: "OpenSourceAndServiceInfo",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        viewController.openSourceLicenseFactory = openSourceLicenseFactory
        viewController.textPopupFactory = textPopupFactory
        return viewController
    }
}

extension ServiceInfoViewController {
    private func inputBind() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .withUnretained(self)
            .withLatestFrom(viewModel.output.dataSource) { ($0.0, $0.1, $1) }
            .subscribe(onNext: { owner, indexPath, dataSource in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                let model = dataSource[indexPath.row]
                switch model.identifier {
                case .termsOfUse:
                    let vc = ContractViewController.viewController(type: .service)
                    vc.modalPresentationStyle = .fullScreen
                    owner.present(vc, animated: true)
                case .privacy:
                    let vc = ContractViewController.viewController(type: .privacy)
                    vc.modalPresentationStyle = .fullScreen
                    owner.present(vc, animated: true)
                case .openSourceLicense:
                    let vc = owner.openSourceLicenseFactory.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .removeCache:
                    owner.viewModel.input.requestCacheSize.onNext(())
                case .versionInfomation:
                    return
                }
            }).disposed(by: disposeBag)
    }

    private func outputBind() {
        viewModel.output
            .dataSource
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ServiceInfoCell",
                    for: IndexPath(row: index, section: 0)
                ) as? ServiceInfoCell else {
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)

        viewModel.output
            .cacheSizeString
            .withUnretained(self)
            .subscribe(onNext: { owner, sizeString in

                guard let textPopupVC = owner.textPopupFactory.makeView(
                    text: "캐시 데이터(\(sizeString))를 지우시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: { owner.viewModel.input.removeCache.onNext(()) },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }

                owner.showBottomSheet(content: textPopupVC)
            }).disposed(by: disposeBag)

        viewModel.output
            .showToast
            .withUnretained(self)
            .subscribe(onNext: { owner, message in
                owner.showToast(
                    text: message,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
            }).disposed(by: disposeBag)
    }

    private func bindBtn() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension ServiceInfoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ServiceInfoViewController {
    private func configureUI() {
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        titleStringLabel.text = "서비스 정보"
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleStringLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        titleStringLabel.setTextWithAttributes(kernValue: -0.5)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 20))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
}
