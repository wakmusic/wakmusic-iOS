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
    private var appPushSettingFactory: AppPushSettingFactory!
    private var serviceTermsFactory: ServiceTermFactory!
    private var privacyFactory: PrivacyFactory!
    private var openSourceLicenseFactory: OpenSourceLicenseFactory!

    let settingView = SettingView()

    override func loadView() {
        view = settingView
    }

    public static func viewController(
        reactor: SettingReactor,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory,
        appPushSettingFactory: AppPushSettingFactory,
        serviceTermsFactory: ServiceTermFactory,
        privacyFactory: PrivacyFactory,
        openSourceLicenseFactory: OpenSourceLicenseFactory
    ) -> SettingViewController {
        let viewController = SettingViewController(reactor: reactor)
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        viewController.appPushSettingFactory = appPushSettingFactory
        viewController.serviceTermsFactory = serviceTermsFactory
        viewController.privacyFactory = privacyFactory
        viewController.openSourceLicenseFactory = openSourceLicenseFactory
        return viewController
    }

    override func bindState(reactor: SettingReactor) {
        reactor.pulse(\.$navigateType)
            .compactMap { $0 }
            .bind(with: self) { owner, navigate in
                switch navigate {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .appPushSetting:
                    let vc = owner.appPushSettingFactory.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .serviceTerms:
                    let vc = owner.serviceTermsFactory.makeView()
                    vc.modalPresentationStyle = .overFullScreen
                    owner.present(vc, animated: true)
                case .privacy:
                    let vc = owner.privacyFactory.makeView()
                    vc.modalPresentationStyle = .overFullScreen
                    owner.present(vc, animated: true)
                case .openSource:
                    let vc = owner.openSourceLicenseFactory.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$cacheSize)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, cachSize in
                guard let textPopupVC = owner.textPopUpFactory.makeView(
                    text: "캐시 데이터(\(cachSize))를 지우시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        owner.reactor?.action.onNext(.confirmRemoveCacheButtonDidTap)
                    },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }
                owner.showFittedSheets(content: textPopupVC)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, message in
                owner.showToast(
                    text: message,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$withDrawButtonDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                guard let secondConfirmVC = owner.textPopUpFactory.makeView(
                    text: "정말 탈퇴하시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        owner.reactor?.action.onNext(.confirmWithDrawButtonDidTap)
                    },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }
                guard let firstConfirmVC = owner.textPopUpFactory.makeView(
                    text: "회원탈퇴 신청을 하시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        owner.showFittedSheets(content: secondConfirmVC)
                    },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }
                owner.showFittedSheets(content: firstConfirmVC)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$withDrawResult)
            .compactMap { $0 }
            .bind(with: self) { owner, withDrawResult in
                let status = withDrawResult.status
                let description = withDrawResult.description
                guard let textPopUpVC = owner.textPopUpFactory.makeView(
                    text: (status == 200) ? "회원탈퇴가 완료되었습니다.\n이용해주셔서 감사합니다." : description,
                    cancelButtonIsHidden: true,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        if status == 200 {
                            owner.navigationController?.popViewController(animated: true)
                        }
                    },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }
                owner.showFittedSheets(content: textPopUpVC)
            }
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
