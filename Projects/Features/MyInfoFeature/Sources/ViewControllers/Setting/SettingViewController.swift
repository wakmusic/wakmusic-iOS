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
    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!
    private var appPushSettingComponent: AppPushSettingComponent!
    private var serviceTermsComponent: ServiceTermsComponent!
    private var privacyComponent: PrivacyComponent!
    private var openSourceLicenseComponent: OpenSourceLicenseComponent!

    let settingView = SettingView()

    override func loadView() {
        view = settingView
    }

    public static func viewController(
        reactor: SettingReactor,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory,
        appPushSettingComponent: AppPushSettingComponent,
        serviceTermsComponent: ServiceTermsComponent,
        privacyComponent: PrivacyComponent,
        openSourceLicenseComponent: OpenSourceLicenseComponent
    ) -> SettingViewController {
        let viewController = SettingViewController(reactor: reactor)
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        viewController.appPushSettingComponent = appPushSettingComponent
        viewController.serviceTermsComponent = serviceTermsComponent
        viewController.privacyComponent = privacyComponent
        viewController.openSourceLicenseComponent = openSourceLicenseComponent
        return viewController
    }

    override func bindState(reactor: SettingReactor) {
        reactor.pulse(\.$dismissButtonDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                print("뒤로가기 버튼 눌림")
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$withDrawButtonDidTap)
            .compactMap { $0 }
            .bind { _ in print("회원탈퇴 버튼 눌림") }
            .disposed(by: disposeBag)

        reactor.pulse(\.$appPushSettingButtonDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                let vc = owner.appPushSettingComponent.makeView()
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$serviceTermsNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                let vc = owner.serviceTermsComponent.makeView()
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$privacyNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                let vc = owner.privacyComponent.makeView()
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$openSourceNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                let vc = owner.openSourceLicenseComponent.makeView()
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: SettingReactor) {
        settingView.rx.dismissButtonDidTap
            .map { SettingReactor.Action.dismissButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.withDrawButtonDidTap
            .map { SettingReactor.Action.withDrawButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.appPushSettingNavigationButtonDidTap
            .map { SettingReactor.Action.appPushSettingNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.termsNavigationButtonDidTap
            .map { SettingReactor.Action.serviceTermsNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.privacyNavigationButtonDidTap
            .map { SettingReactor.Action.privacyNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.openSourceNavigationButtonDidTap
            .map { SettingReactor.Action.openSourceNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.removeCacheButtonDidTap
            .map { SettingReactor.Action.removeCacheButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.versionInfoButtonDidTap
            .map { SettingReactor.Action.versionInfoButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
