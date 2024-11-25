import AuthDomainInterface
import BaseDomainInterface
import FirebaseMessaging
import Foundation
import Kingfisher
import LogManager
import NaverThirdPartyLogin
import NotificationDomainInterface
import ReactorKit
import UserDomainInterface
import Utility

final class SettingReactor: Reactor {
    enum Action {
        case dismissButtonDidTap
        case withDrawButtonDidTap
        case confirmWithDrawButtonDidTap
        case appPushSettingNavigationDidTap
        case serviceTermsNavigationDidTap
        case privacyNavigationDidTap
        case openSourceNavigationDidTap
        case removeCacheButtonDidTap
        case confirmRemoveCacheButtonDidTap
        case confirmLogoutButtonDidTap
        case versionInfoButtonDidTap
        case showToast(String)
    }

    enum Mutation {
        case navigate(NavigateType?)
        case withDrawButtonDidTap
        case removeCacheButtonDidTap(cacheSize: String)
        case confirmRemoveCacheButtonDidTap
        case showToast(String)
        case withDrawResult(BaseEntity)
        case updateIsHiddenLogoutButton(Bool)
        case updateIsHiddenWithDrawButton(Bool)
        case changedNotificationAuthorizationStatus(Bool)
        case updateIsShowActivityIndicator(Bool)
        case reloadTableView
    }

    enum NavigateType {
        case dismiss
        case appPushSetting
        case serviceTerms
        case privacy
        case openSource
    }

    struct State {
        var userInfo: UserInfo?
        var isHiddenLogoutButton: Bool
        var isHiddenWithDrawButton: Bool
        var notificationAuthorizationStatus: Bool
        var isShowActivityIndicator: Bool
        @Pulse var cacheSize: String?
        @Pulse var toastMessage: String?
        @Pulse var navigateType: NavigateType?
        @Pulse var withDrawButtonDidTap: Bool?
        @Pulse var confirmRemoveCacheButtonDidTap: Bool?
        @Pulse var withDrawResult: BaseEntity?
        @Pulse var reloadTableView: Void?
    }

    var initialState: State
    private var disposeBag = DisposeBag()
    private let withDrawUserInfoUseCase: any WithdrawUserInfoUseCase
    private let logoutUseCase: any LogoutUseCase
    private let updateNotificationTokenUseCase: any UpdateNotificationTokenUseCase

    init(
        withDrawUserInfoUseCase: WithdrawUserInfoUseCase,
        logoutUseCase: LogoutUseCase,
        updateNotificationTokenUseCase: UpdateNotificationTokenUseCase
    ) {
        self.initialState = .init(
            userInfo: Utility.PreferenceManager.shared.userInfo,
            isHiddenLogoutButton: true,
            isHiddenWithDrawButton: true,
            notificationAuthorizationStatus: PreferenceManager.shared.pushNotificationAuthorizationStatus ?? false,
            isShowActivityIndicator: false
        )
        self.withDrawUserInfoUseCase = withDrawUserInfoUseCase
        self.logoutUseCase = logoutUseCase
        self.updateNotificationTokenUseCase = updateNotificationTokenUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonDidTap:
            return dismissButtonDidTap()
        case .withDrawButtonDidTap:
            return withDrawButtonDidTap()
        case .appPushSettingNavigationDidTap:
            return appPushSettingNavigationDidTap()
        case .serviceTermsNavigationDidTap:
            return serviceTermsNavigationDidTap()
        case .privacyNavigationDidTap:
            return privacyNavigationDidTap()
        case .openSourceNavigationDidTap:
            return openSourceNavigationDidTap()
        case .removeCacheButtonDidTap:
            return removeCacheButtonDidTap()
        case .versionInfoButtonDidTap:
            return versionInfoButtonDidTap()
        case .confirmRemoveCacheButtonDidTap:
            return confirmRemoveCacheButtonDidTap()
        case .confirmLogoutButtonDidTap:
            return confirmLogoutButtonDidTap()
        case let .showToast(message):
            return showToast(message: message)
        case .confirmWithDrawButtonDidTap:
            return confirmWithDrawButtonDidTap()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .navigate(navigate):
            newState.navigateType = navigate
        case .withDrawButtonDidTap:
            newState.withDrawButtonDidTap = true
        case let .removeCacheButtonDidTap(cacheSize):
            newState.cacheSize = cacheSize
        case .confirmRemoveCacheButtonDidTap:
            newState.confirmRemoveCacheButtonDidTap = true
        case let .showToast(message):
            newState.toastMessage = message
        case let .withDrawResult(withDrawResult):
            newState.withDrawResult = withDrawResult
        case let .updateIsHiddenLogoutButton(isHiddenLogoutButton):
            newState.isHiddenLogoutButton = isHiddenLogoutButton
        case let .updateIsHiddenWithDrawButton(isHiddenWithDrawButton):
            newState.isHiddenWithDrawButton = isHiddenWithDrawButton
        case let .changedNotificationAuthorizationStatus(granted):
            newState.notificationAuthorizationStatus = granted
        case let .updateIsShowActivityIndicator(isShow):
            newState.isShowActivityIndicator = isShow
        case .reloadTableView:
            newState.reloadTableView = ()
        }
        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let updateIsLoggedInMutation = PreferenceManager.shared.$userInfo.map { $0?.ID }
            .distinctUntilChanged()
            .map { $0 != nil }
            .withUnretained(self)
            .flatMap { owner, isLoggedIn -> Observable<Mutation> in
                return .concat(
                    owner.updateIsHiddenLogoutButton(isLoggedIn),
                    owner.updateIsHiddenWithDrawButton(isLoggedIn)
                )
            }

        let updatepushNotificationAuthorizationStatusMutation = PreferenceManager.shared
            .$pushNotificationAuthorizationStatus
            .skip(1)
            .distinctUntilChanged()
            .map { $0 ?? false }
            .flatMap { granted -> Observable<Mutation> in
                return .just(.changedNotificationAuthorizationStatus(granted))
            }

        let updatePlayTypeMutation = PreferenceManager.shared.$songPlayPlatformType
            .distinctUntilChanged()
            .map { $0 ?? .youtube }
            .flatMap { playType -> Observable<Mutation> in
                return .just(.reloadTableView)
            }

        return Observable.merge(
            mutation,
            updateIsLoggedInMutation,
            updatepushNotificationAuthorizationStatusMutation,
            updatePlayTypeMutation
        )
    }
}

private extension SettingReactor {
    func updateIsHiddenLogoutButton(_ isLoggedIn: Bool) -> Observable<Mutation> {
        let isHidden = isLoggedIn == false
        return .just(.updateIsHiddenLogoutButton(isHidden))
    }

    func updateIsHiddenWithDrawButton(_ isLoggedIn: Bool) -> Observable<Mutation> {
        let isHidden = isLoggedIn == false
        return .just(.updateIsHiddenWithDrawButton(isHidden))
    }

    func dismissButtonDidTap() -> Observable<Mutation> {
        return .just(.navigate(.dismiss))
    }

    func confirmLogoutButtonDidTap() -> Observable<Mutation> {
        let notificationGranted = PreferenceManager.shared.pushNotificationAuthorizationStatus ?? false
        let logoutUseCase = logoutUseCase.execute(localOnly: false)
            .andThen(
                .concat(
                    .just(.updateIsHiddenLogoutButton(true)),
                    .just(.updateIsHiddenWithDrawButton(true)),
                    .just(.showToast("로그아웃 되었습니다."))
                )
            )
            .catch { error in
                let description = error.asWMError.errorDescription ?? ""
                return Observable.just(Mutation.showToast(description))
            }

        if notificationGranted {
            return Messaging.messaging().fetchRxPushToken()
                .asObservable()
                .catchAndReturn("")
                .flatMap { [updateNotificationTokenUseCase] token -> Observable<Void> in
                    return token.isEmpty ?
                        Observable.just(()) :
                        updateNotificationTokenUseCase.execute(type: .delete)
                        .andThen(Observable.just(()))
                        .catchAndReturn(())
                }
                .flatMap { _ in
                    return Observable.concat(
                        .just(.updateIsShowActivityIndicator(true)),
                        logoutUseCase,
                        .just(.updateIsShowActivityIndicator(false))
                    )
                }

        } else {
            return Observable.concat(
                .just(.updateIsShowActivityIndicator(true)),
                logoutUseCase,
                .just(.updateIsShowActivityIndicator(false))
            )
        }
    }

    func withDrawButtonDidTap() -> Observable<Mutation> {
        return .just(.withDrawButtonDidTap)
    }

    func confirmWithDrawButtonDidTap() -> Observable<Mutation> {
        return withDrawUserInfoUseCase.execute()
            .andThen(
                .concat(
                    handleThirdPartyWithDraw(),
                    clearUserInfo()
                )
            )
            .catch { error in
                let baseEntity = BaseEntity(
                    status: 0,
                    description: error.asWMError.errorDescription ?? ""
                )
                return Observable.just(baseEntity)
            }
            .map { Mutation.withDrawResult($0) }
    }

    func appPushSettingNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.appPushSetting))
    }

    func serviceTermsNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.serviceTerms))
    }

    func privacyNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.privacy))
    }

    func openSourceNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.openSource))
    }

    func removeCacheButtonDidTap() -> Observable<Mutation> {
        calculateCacheSize()
            .asObservable()
            .map { cacheSize in
                Mutation.removeCacheButtonDidTap(cacheSize: cacheSize)
            }
    }

    func confirmRemoveCacheButtonDidTap() -> Observable<Mutation> {
        return Completable.create { completable in
            ImageCache.default.clearCache {
                completable(.completed)
            }
            return Disposables.create()
        }
        .andThen(
            Observable.just(Mutation.showToast("캐시 데이터가 삭제되었습니다."))
        )
    }

    func calculateCacheSize() -> Single<String> {
        return Single.create { single in
            ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case let .success(size):
                    let formatter = ByteCountFormatter()
                    formatter.allowedUnits = .useAll
                    formatter.countStyle = .decimal

                    let sizeString = formatter.string(fromByteCount: Int64(size))
                    single(.success(sizeString))
                case let .failure(error):
                    let description = error.asWMError.errorDescription ?? ""
                    single(.success(description))
                }
            }
            return Disposables.create()
        }
    }

    func versionInfoButtonDidTap() -> Observable<Mutation> {
        return .empty()
    }

    func showToast(message: String) -> Observable<Mutation> {
        return .just(.showToast(message))
    }
}

private extension SettingReactor {
    func handleThirdPartyWithDraw() -> Observable<BaseEntity> {
        let platform = Utility.PreferenceManager.shared.userInfo?.platform
        if platform == "naver" {
            Task { @MainActor in
                NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
            }
        }
        return .empty()
    }

    func clearUserInfo() -> Observable<BaseEntity> {
        PreferenceManager.clearUserInfo()
        return Observable.create { observable in
            observable.onNext(BaseEntity(
                status: 200,
                description: ""
            ))
            observable.onCompleted()
            return Disposables.create {}
        }
    }
}
