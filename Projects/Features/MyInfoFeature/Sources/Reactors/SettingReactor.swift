import Foundation
import Kingfisher
import LogManager
import ReactorKit
import Utility

final class SettingReactor: Reactor {
    enum Action {
        case dismissButtonDidTap
        case withDrawButtonDidTap
        case appPushSettingNavigationDidTap
        case serviceTermsNavigationDidTap
        case privacyNavigationDidTap
        case openSourceNavigationDidTap
        case removeCacheButtonDidTap
        case confirmRemoveCacheButtonDidTap
        case versionInfoButtonDidTap
        case showToast(String)
    }

    enum Mutation {
        case dismissButtonDidTap
        case withDrawButtonDidTap
        case appPushSettingButtonDidTap
        case serviceTermsNavigationDidTap
        case privacyNavigationDidTap
        case openSourceNavigationDidTap
        case removeCacheButtonDidTap(cacheSize: String)
        case confirmRemoveCacheButtonDidTap
        case versionInfoButtonDidTap
        case showToast(String)
    }

    struct State {
        var userInfo: UserInfo?
        @Pulse var cacheSize: String?
        @Pulse var toastMessage: String?
        @Pulse var dismissButtonDidTap: Bool?
        @Pulse var withDrawButtonDidTap: Bool?
        @Pulse var appPushSettingButtonDidTap: Bool?
        @Pulse var serviceTermsNavigationDidTap: Bool?
        @Pulse var privacyNavigationDidTap: Bool?
        @Pulse var openSourceNavigationDidTap: Bool?
        @Pulse var confirmRemoveCacheButtonDidTap: Bool?
        @Pulse var versionInfoButtonDidTap: Bool?
    }

    var initialState: State
    private var disposeBag = DisposeBag()

    init() {
        self.initialState = .init(
            userInfo: Utility.PreferenceManager.userInfo
        )
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
        case let .showToast(message):
            return showToast(message: message)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .dismissButtonDidTap:
            newState.dismissButtonDidTap = true
        case .withDrawButtonDidTap:
            newState.withDrawButtonDidTap = true
        case .appPushSettingButtonDidTap:
            newState.appPushSettingButtonDidTap = true
        case .serviceTermsNavigationDidTap:
            newState.serviceTermsNavigationDidTap = true
        case .privacyNavigationDidTap:
            newState.privacyNavigationDidTap = true
        case .openSourceNavigationDidTap:
            newState.openSourceNavigationDidTap = true
        case let .removeCacheButtonDidTap(cacheSize):
            newState.cacheSize = cacheSize
        case .versionInfoButtonDidTap:
            newState.versionInfoButtonDidTap = true
        case .confirmRemoveCacheButtonDidTap:
            newState.confirmRemoveCacheButtonDidTap = true
        case let .showToast(message):
            newState.toastMessage = message
        }
        return newState
    }
}

private extension SettingReactor {
    func dismissButtonDidTap() -> Observable<Mutation> {
        return .just(.dismissButtonDidTap)
    }

    func withDrawButtonDidTap() -> Observable<Mutation> {
        return .just(.withDrawButtonDidTap)
    }

    func appPushSettingNavigationDidTap() -> Observable<Mutation> {
        return .just(.appPushSettingButtonDidTap)
    }

    func serviceTermsNavigationDidTap() -> Observable<Mutation> {
        return .just(.serviceTermsNavigationDidTap)
    }

    func privacyNavigationDidTap() -> Observable<Mutation> {
        return .just(.privacyNavigationDidTap)
    }

    func openSourceNavigationDidTap() -> Observable<Mutation> {
        return .just(.openSourceNavigationDidTap)
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
        return .just(.versionInfoButtonDidTap)
    }

    func showToast(message: String) -> Observable<Mutation> {
        return .just(.showToast(message))
    }
}
