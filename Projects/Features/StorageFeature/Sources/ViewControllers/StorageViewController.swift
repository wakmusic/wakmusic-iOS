import BaseFeature
import DesignSystem
import KeychainModule
import RxCocoa
import RxRelay
import RxSwift
import SignInFeatureInterface
import UIKit
import Utility

public final class StorageViewController: BaseViewController, ViewControllerFromStoryBoard, ContainerViewType {
    @IBOutlet public weak var contentView: UIView!

    var signInFactory: SignInFactory!
    var afterLoginComponent: AfterLoginComponent!

    lazy var bfLoginView = signInFactory.makeView()
    lazy var afLoginView = afterLoginComponent.makeView()
    let disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public static func viewController(
        signInFactory: SignInFactory,
        afterLoginComponent: AfterLoginComponent
    ) -> StorageViewController {
        let viewController = StorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.signInFactory = signInFactory
        viewController.afterLoginComponent = afterLoginComponent
        return viewController
    }
}

extension StorageViewController {
    private func configureUI() {
        bindRx()
    }

    private func bindRx() {
        // TODO: 나중에 보관함 작업 리팩할 때

//        Utility.PreferenceManager.$userInfo
//            .map { $0 != nil }
//            .subscribe(onNext: { [weak self] isLogin in
//                guard let self = self else {
//                    return
//                }
//                DEBUG_LOG(isLogin)
//
//                if isLogin {
//                    if let _ = self.children.first as? LoginViewController {
//                        self.remove(asChildViewController: self.bfLoginView)
//                    }
//                    self.add(asChildViewController: self.afLoginView)
//
//                } else {
//                    if let _ = self.children.first as? AfterLoginViewController {
//                        self.remove(asChildViewController: self.afLoginView)
//                    }
//                    self.add(asChildViewController: self.bfLoginView)
//                }
//            }).disposed(by: disposeBag)
    }
}

public extension StorageViewController {
    // TODO: 나중에 보관함 작업 리팩할 때
    func equalHandleTapped() {
//        let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
//        if viewControllersCount > 1 {
//            self.navigationController?.popToRootViewController(animated: true)
//        } else {
//            if let nonLogin = children.first as? LoginViewController {
//                nonLogin.scrollToTop()
//            } else if let isLogin = children.first as? AfterLoginViewController {
//                isLogin.scrollToTop()
//            }
//        }
    }
}
