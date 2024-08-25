import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Foundation
import LogManager
import MyInfoFeatureInterface
import NVActivityIndicatorView
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import Utility

final class SettingViewController: BaseReactorViewController<SettingReactor> {
    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!
    private var serviceTermsFactory: ServiceTermFactory!
    private var privacyFactory: PrivacyFactory!
    private var openSourceLicenseFactory: OpenSourceLicenseFactory!
    private var togglePopupFactory: PlayTypeTogglePopupFactory!

    let settingView = SettingView()
    let settingItemDataSource = SettingItemDataSource()

    override func loadView() {
        view = settingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setSettingItemTableView()
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .setting))
    }

    public static func viewController(
        reactor: SettingReactor,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory,
        serviceTermsFactory: ServiceTermFactory,
        privacyFactory: PrivacyFactory,
        openSourceLicenseFactory: OpenSourceLicenseFactory,
        togglePopupFactory: PlayTypeTogglePopupFactory
    ) -> SettingViewController {
        let viewController = SettingViewController(reactor: reactor)
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        viewController.serviceTermsFactory = serviceTermsFactory
        viewController.privacyFactory = privacyFactory
        viewController.openSourceLicenseFactory = openSourceLicenseFactory
        viewController.togglePopupFactory = togglePopupFactory
        return viewController
    }

    override func bindState(reactor: SettingReactor) {
        reactor.pulse(\.$reloadTableView)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("$reloadTableView")
                owner.settingView.settingItemTableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isShowActivityIndicator)
            .distinctUntilChanged()
            .bind(with: self) { owner, isShow in
                owner.settingView.updateActivityIndicatorState(isPlaying: isShow)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.isHiddenWithDrawButton)
            .distinctUntilChanged()
            .bind(with: self) { owner, isHidden in
                owner.settingView.updateIsHiddenWithDrawButton(isHidden: isHidden)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.isHiddenLogoutButton)
            .distinctUntilChanged()
            .bind(with: self) { owner, isHidden in
                owner.settingItemDataSource.updateCurrentSettingItems(isHidden: isHidden)
                owner.settingView.updateIsHiddenLogoutButton(isHidden: isHidden)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.notificationAuthorizationStatus)
            .distinctUntilChanged()
            .bind(with: self) { owner, granted in
                owner.settingView.updateNotificationAuthorizationStatus(granted: granted)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$navigateType)
            .compactMap { $0 }
            .bind(with: self) { owner, navigate in
                switch navigate {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .appPushSetting:
                    guard let openSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(openSettingsURL)
                case .serviceTerms:
                    let vc = owner.serviceTermsFactory.makeView()
                    vc.modalPresentationStyle = .fullScreen
                    owner.present(vc, animated: true)
                case .privacy:
                    let vc = owner.privacyFactory.makeView()
                    vc.modalPresentationStyle = .fullScreen
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
                        let log = SettingAnalyticsLog.completeRemoveCache(size: cachSize)
                        LogManager.analytics(log)

                        owner.reactor?.action.onNext(.confirmRemoveCacheButtonDidTap)
                    },
                    cancelCompletion: nil
                ) as? TextPopupViewController else {
                    return
                }
                owner.showBottomSheet(content: textPopupVC)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, message in
                owner.showToast(text: message, options: [.tabBar])
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$withDrawButtonDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                let makeSecondConfirmVC: () -> UIViewController = {
                    owner.textPopUpFactory.makeView(
                        text: "정말 탈퇴하시겠습니까?",
                        cancelButtonIsHidden: false,
                        completion: {
                            let log = SettingAnalyticsLog.completeWithdraw
                            LogManager.analytics(log)

                            owner.reactor?.action.onNext(.confirmWithDrawButtonDidTap)
                        }
                    )
                }
                let firstConfirmVC = owner.textPopUpFactory.makeView(
                    text: "회원탈퇴 신청을 하시겠습니까?",
                    cancelButtonIsHidden: false,
                    completion: {
                        let secondConfirmVC = makeSecondConfirmVC()
                        owner.showBottomSheet(content: secondConfirmVC)
                    }
                )
                owner.showBottomSheet(content: firstConfirmVC)
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
                owner.showBottomSheet(content: textPopUpVC)
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: SettingReactor) {
        settingView.rx.dismissButtonDidTap
            .map { Reactor.Action.dismissButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.withDrawButtonDidTap
            .do(onNext: {
                LogManager.analytics(SettingAnalyticsLog.clickWithdrawButton)
            })
            .map { Reactor.Action.withDrawButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDelegate {
    func setSettingItemTableView() {
        settingView.settingItemTableView.dataSource = settingItemDataSource
        settingView.settingItemTableView.delegate = self
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingItemTableViewCell else { return }
        guard let category = cell.category else { return }

        let togglePopupVC = togglePopupFactory.makeView(
            completion: { selectedItemString in
                switch selectedItemString {
                case "YouTube":
                    PreferenceManager.playWithYoutubeMusic = false
                case "YouTube Music":
                    PreferenceManager.playWithYoutubeMusic = true
                default:
                    break
                }
            },
            cancelCompletion: {}
        )
        togglePopupVC.modalPresentationStyle = .overFullScreen

        let textPopUpVC = textPopUpFactory.makeView(
            text: "로그아웃 하시겠습니까?",
            cancelButtonIsHidden: false,
            confirmButtonText: "확인",
            cancelButtonText: "취소",
            completion: { [weak self] in
                guard let self else { return }
                let log = SettingAnalyticsLog.completeLogout
                LogManager.analytics(log)

                self.reactor?.action.onNext(.confirmLogoutButtonDidTap)
            },
            cancelCompletion: {}
        )

        switch category {
        case .appPush:
            LogManager.analytics(SettingAnalyticsLog.clickNotificationButton)
            reactor?.action.onNext(.appPushSettingNavigationDidTap)
        case .playType:
            self.present(togglePopupVC, animated: false)
        case .serviceTerms: LogManager.analytics(SettingAnalyticsLog.clickTermsOfServiceButton)
            reactor?.action.onNext(.serviceTermsNavigationDidTap)
        case .privacy:
            LogManager.analytics(SettingAnalyticsLog.clickPrivacyPolicyButton)
            reactor?.action.onNext(.privacyNavigationDidTap)
        case .openSource:
            LogManager.analytics(SettingAnalyticsLog.clickOpensourceButton)
            reactor?.action.onNext(.openSourceNavigationDidTap)
        case .removeCache:
            LogManager.analytics(SettingAnalyticsLog.clickRemoveCacheButton)
            reactor?.action.onNext(.removeCacheButtonDidTap)
        case .logout:
            LogManager.analytics(SettingAnalyticsLog.clickLogoutButton)
            showBottomSheet(content: textPopUpVC, size: .fixed(234))
        case .versionInfo:
            LogManager.analytics(SettingAnalyticsLog.clickVersionButton)
            reactor?.action.onNext(.versionInfoButtonDidTap)
        }
    }
}
