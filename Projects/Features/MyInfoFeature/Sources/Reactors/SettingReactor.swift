import AuthDomainInterface
import BaseDomainInterface
import Foundation
import Kingfisher
import LogManager
import NaverThirdPartyLogin
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
        case changedUserInfo(UserInfo?)
        case showToast(String)
        case updateIsHiddenLogoutButton(Bool)
        case updateIsHiddenWithDrawButton(Bool)
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
        @Pulse var cacheSize: String?
        @Pulse var toastMessage: String?
        @Pulse var navigateType: NavigateType?
        @Pulse var withDrawButtonDidTap: Bool?
        @Pulse var confirmRemoveCacheButtonDidTap: Bool?
        @Pulse var withDrawResult: BaseEntity?
    }

    var initialState: State
    private var disposeBag = DisposeBag()
    private let withDrawUserInfoUseCase: any WithdrawUserInfoUseCase
    private let logoutUseCase: any LogoutUseCase
    private let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    init(
        withDrawUserInfoUseCase: WithdrawUserInfoUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.initialState = .init(
            userInfo: Utility.PreferenceManager.userInfo,
            isHiddenLogoutButton: true,
            isHiddenWithDrawButton: true
        )
        self.withDrawUserInfoUseCase = withDrawUserInfoUseCase
        self.logoutUseCase = logoutUseCase
        observeUserInfoChanges()
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
        case let .changedUserInfo(userInfo):
            return .concat (
                updateIsHiddenLogoutButton(userInfo),
                updateIsHiddenWithDrawButton(userInfo)
            )

        case let .updateIsHiddenLogoutButton(isHidden):
            return .just(.updateIsHiddenLogoutButton(isHidden))
        case let .updateIsHiddenWithDrawButton(isHidden):
            return .just(.updateIsHiddenWithDrawButton(isHidden))
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
        }
        return newState
    }
}

private extension SettingReactor {
    func observeUserInfoChanges() {
        PreferenceManager.$userInfo
            .bind(with: self) { owner, userInfo in
                owner.action.onNext(.changedUserInfo(userInfo))
            }
            .disposed(by: disposeBag)
    }

    func updateIsHiddenLogoutButton(_ userInfo: UserInfo?) -> Observable<Mutation> {
        let isHidden = userInfo == nil
        return .just(.updateIsHiddenLogoutButton(isHidden))
    }

    func updateIsHiddenWithDrawButton(_ userInfo: UserInfo?) -> Observable<Mutation> {
        let isHidden = userInfo == nil
        return .just(.updateIsHiddenWithDrawButton(isHidden))
    }

    func dismissButtonDidTap() -> Observable<Mutation> {
        return .just(.navigate(.dismiss))
    }

    func confirmLogoutButtonDidTap() -> Observable<Mutation> {
        logoutUseCase.execute()
            .subscribe(with: self, onCompleted: { owner in
                owner.action.onNext(.updateIsHiddenLogoutButton(true))
                owner.action.onNext(.updateIsHiddenWithDrawButton(true))
                owner.action.onNext(.showToast("로그아웃 되었습니다."))
            }, onError: { owner, error in
                let description = error.asWMError.errorDescription ?? ""
                owner.action.onNext(.showToast(description))
            })
            .disposed(by: disposeBag)
        return .empty()
    }

    func withDrawButtonDidTap() -> Observable<Mutation> {
        let mutation: Mutation = currentState.userInfo == nil
            ? .showToast("로그인이 필요합니다.")
            : .withDrawButtonDidTap
        return .just(mutation)
    }

    func confirmWithDrawButtonDidTap() -> Observable<Mutation> {
        // TODO: 회원탈퇴 처리
        return withDrawUserInfoUseCase.execute()
            .andThen(
                .concat(
                    handleThirdPartyWithDraw(),
                    logout()
                )
            )
            .map { Mutation.withDrawResult($0) }
            .catch { error in
                let baseEntity = BaseEntity(status: 0, description: error.asWMError.errorDescription ?? "")
                return Observable.just(Mutation.withDrawResult(baseEntity))
            }
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
        let cacheSize = calculateCacheSize()
        return .just(.removeCacheButtonDidTap(cacheSize: cacheSize))
    }

    func confirmRemoveCacheButtonDidTap() -> Observable<Mutation> {
        ImageCache.default.clearDiskCache()
        action.onNext(.showToast("캐시 데이터가 삭제되었습니다."))
        return .just(.confirmRemoveCacheButtonDidTap)
    }

    func calculateCacheSize() -> String {
        var str = ""
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case let .success(size):
                let sizeString = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
                str = sizeString
            case let .failure(error):
                str = ""
            }
        }
        return str
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
        let platform = Utility.PreferenceManager.userInfo?.platform
        if platform == "naver" {
            naverLoginInstance?.requestDeleteToken()
        }
        return .empty()
    }

    func logout() -> Observable<BaseEntity> {
        logoutUseCase.execute()
            .andThen(
                Observable.create { observable in
                    observable.onNext(BaseEntity(
                        status: 200,
                        description: "회원탈퇴가 완료되었습니다.\n이용해주셔서 감사합니다."
                    ))
                    observable.onCompleted()
                    return Disposables.create {}
                }
            )
            .catch { error in
                Observable.create { observable in
                    observable.onNext(BaseEntity(
                        status: 0,
                        description: error.asWMError.errorDescription ?? ""
                    ))
                    observable.onCompleted()
                    return Disposables.create {}
                }
            }
    }
}
