import Foundation
import LogManager
import ReactorKit
import Utility

final class SettingReactor: Reactor {
    enum Action {
        case dismissButtonDidTap
        case withDrawButtonDidTap
        case notiNavigationDidTap
        case termsNavigationDidTap
        case privacyNavigationDidTap
        case openSourceNavigationDidTap
        case removeCacheButtonDidTap
        case versionInfoButtonDidTap
    }

    enum Mutation {
        case dismissButtonDidTap
        case withDrawButtonDidTap
        case notiButtonDidTap
        case termsNavigationDidTap
        case privacyNavigationDidTap
        case openSourceNavigationDidTap
        case removeCacheButtonDidTap
        case versionInfoButtonDidTap
    }

    struct State {
        var userInfo: UserInfo?
        @Pulse var dismissButtonDidTap: Bool?
        @Pulse var withDrawButtonDidTap: Bool?
        @Pulse var notiButtonDidTap: Bool?
        @Pulse var termsNavigationDidTap: Bool?
        @Pulse var privacyNavigationDidTap: Bool?
        @Pulse var openSourceNavigationDidTap: Bool?
        @Pulse var removeCacheButtonDidTap: Bool?
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
        case .notiNavigationDidTap:
            return notiButtonDidTap()
        case .termsNavigationDidTap:
            return termsNavigationDidTap()
        case .privacyNavigationDidTap:
            return privacyNavigationDidTap()
        case .openSourceNavigationDidTap:
            return openSourceNavigationDidTap()
        case .removeCacheButtonDidTap:
            return removeCacheButtonDidTap()
        case .versionInfoButtonDidTap:
            return versionInfoButtonDidTap()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .dismissButtonDidTap:
            newState.dismissButtonDidTap = true
        case .withDrawButtonDidTap:
            newState.withDrawButtonDidTap = true
        case .notiButtonDidTap:
            newState.notiButtonDidTap = true
        case .termsNavigationDidTap:
            newState.termsNavigationDidTap = true
        case .privacyNavigationDidTap:
            newState.privacyNavigationDidTap = true
        case .openSourceNavigationDidTap:
            newState.openSourceNavigationDidTap = true
        case .removeCacheButtonDidTap:
            newState.removeCacheButtonDidTap = true
        case .versionInfoButtonDidTap:
            newState.versionInfoButtonDidTap = true
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

    func notiButtonDidTap() -> Observable<Mutation> {
        return .just(.notiButtonDidTap)
    }

    func termsNavigationDidTap() -> Observable<Mutation> {
        return .just(.termsNavigationDidTap)
    }

    func privacyNavigationDidTap() -> Observable<Mutation> {
        return .just(.privacyNavigationDidTap)
    }

    func openSourceNavigationDidTap() -> Observable<Mutation> {
        return .just(.openSourceNavigationDidTap)
    }

    func removeCacheButtonDidTap() -> Observable<Mutation> {
        return .just(.removeCacheButtonDidTap)
    }

    func versionInfoButtonDidTap() -> Observable<Mutation> {
        return .just(.versionInfoButtonDidTap)
    }
}
