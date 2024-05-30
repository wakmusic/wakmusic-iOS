import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Foundation
import LogManager
import MyInfoFeatureInterface
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import Utility

final class MyInfoViewController: BaseReactorViewController<MyInfoReactor> {
    let myInfoView = MyInfoView()
    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!

    override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func loadView() {
        view = myInfoView
    }

    public static func viewController(
        reactor: MyInfoReactor,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory
    ) -> MyInfoViewController {
        let viewController = MyInfoViewController(reactor: reactor)
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    override func bindState(reactor: MyInfoReactor) {}

    override func bindAction(reactor: MyInfoReactor) {
        myInfoView.rx.loginButtonDidTap.subscribe { _ in
            print("로그인 버튼 눌림")
        }.disposed(by: disposeBag)

        myInfoView.rx.drawButtonDidTap.subscribe { _ in
            print("뽑기 버튼 눌림")
        }.disposed(by: disposeBag)
    }
}
