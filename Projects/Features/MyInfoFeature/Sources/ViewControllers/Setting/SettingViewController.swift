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

final class SettingViewController: BaseReactorViewController<SettingReactor> {
    let settingView = SettingView()

    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!

    override func loadView() {
        view = settingView
    }

    public static func viewController(
        reactor: SettingReactor,
        textPopUpFactory: TextPopUpFactory
    ) -> SettingViewController {
        let viewController = SettingViewController(reactor: reactor)
        viewController.textPopUpFactory = textPopUpFactory
        return viewController
    }

    override func bindState(reactor: SettingReactor) {}

    override func bindAction(reactor: SettingReactor) {
        settingView.rx.privacyNavigationButtonDidTap.subscribe { _ in
            print("privacyNavigationButtonDidTap!")
        }.disposed(by: disposeBag)
    }
}
