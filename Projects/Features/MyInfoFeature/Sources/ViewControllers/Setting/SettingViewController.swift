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
        reactor.pulse(\.$navigateType)
            .compactMap { $0 }
            .bind(with: self) { owner, navigate in
                switch navigate {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .appPushSetting:
                    let vc = owner.appPushSettingComponent.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .serviceTerms:
                    let vc = owner.serviceTermsComponent.makeView()
                    vc.modalPresentationStyle = .overFullScreen
                    owner.present(vc, animated: true)
                case .privacy:
                    let vc = owner.privacyComponent.makeView()
                    vc.modalPresentationStyle = .overFullScreen
                    owner.present(vc, animated: true)
                case .openSource:
                    let vc = owner.openSourceLicenseComponent.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$withDrawButtonDidTap)
            .compactMap { $0 }
            .bind { _ in print("회원탈퇴 버튼 눌림") }
            .disposed(by: disposeBag)

        reactor.pulse(\.$cacheSize)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, cachSize in
                guard let textPopupVC = owner.textPopUpFactory.makeView(
                    text: "캐시 데이터(\(cachSize))를 지우시겠습니까?",
                    cancelButtonIsHidden: false,
                    allowsDragAndTapToDismiss: nil,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        owner.reactor?.action.onNext(.confirmRemoveCacheButtonDidTap)
                    },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }
                #warning("팬모달 이슈 해결되면 변경 예정")
                textPopupVC.modalPresentationStyle = .popover
                owner.present(textPopupVC, animated: true)
                // owner.showPanModal(content: textPopupVC)
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
                    allowsDragAndTapToDismiss: nil,
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
                    allowsDragAndTapToDismiss: nil,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        #warning("팬모달 이슈 해결되면 변경 예정")
                        secondConfirmVC.modalPresentationStyle = .popover
                        owner.present(secondConfirmVC, animated: true)
                        // owner.showPanModal(content: secondConfirmVC)
                    },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }
                #warning("팬모달 이슈 해결되면 변경 예정")
                owner.present(firstConfirmVC, animated: true)
                // self.showPanModal(content: firstConfirmVC)
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
                    allowsDragAndTapToDismiss: nil,
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
                #warning("팬모달 이슈 해결되면 변경 예정")
                textPopUpVC.modalPresentationStyle = .popover
                owner.present(textPopUpVC, animated: true)
                // owner.showPanModal(content: textPopUpVC)
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
