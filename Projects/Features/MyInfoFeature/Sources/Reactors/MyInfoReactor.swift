import Foundation
import LogManager
import ReactorKit
import Utility

final class MyInfoReactor: Reactor {
    enum Action {
        case loginButtonDidTap
        case moreButtonDidTap
        case drawButtonDidTap
        case likeNavigationDidTap
        case qnaNavigationDidTap
        case notiNavigationDidTap
        case mailNavigationDidTap
        case teamNavigationDidTap
        case settingNavigationDidTap
    }

    enum NavigateType {
        case draw, like, qna, noti, mail, team, setting
    }

    enum Mutation {
        case navigate(NavigateType)
        case loginButtonDidTap
        case moreButtonDidTap
    }

    struct State {
        var userInfo: UserInfo?
        @Pulse var loginButtonDidTap: Bool?
        @Pulse var moreButtonDidTap: Bool?
        var navigateType: NavigateType?
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
        case .loginButtonDidTap:
            return loginButtonDidTap()
        case .moreButtonDidTap:
            return moreButtonDidTap()
        case .drawButtonDidTap:
            return drawButtonDidTap()
        case .likeNavigationDidTap:
            return likeNavigationDidTap()
        case .qnaNavigationDidTap:
            return qnaNavigationDidTap()
        case .notiNavigationDidTap:
            return notiNavigationDidTap()
        case .mailNavigationDidTap:
            return mailNavigationDidTap()
        case .teamNavigationDidTap:
            return teamNavigationDidTap()
        case .settingNavigationDidTap:
            return settingNavigationDidTap()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loginButtonDidTap:
            newState.loginButtonDidTap = true

        case .moreButtonDidTap:
            newState.moreButtonDidTap = true

        case let .navigate(navigateType):
            newState.navigateType = navigateType
        }
        return newState
    }
}

private extension MyInfoReactor {
    func loginButtonDidTap() -> Observable<Mutation> {
        return .just(.loginButtonDidTap)
    }

    func moreButtonDidTap() -> Observable<Mutation> {
        return .just(.moreButtonDidTap)
    }

    func drawButtonDidTap() -> Observable<Mutation> {
        return .just(.navigate(.draw))
    }

    func likeNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.like))
    }

    func qnaNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.qna))
    }

    func notiNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.noti))
    }

    func mailNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.mail))
    }

    func teamNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.team))
    }

    func settingNavigationDidTap() -> Observable<Mutation> {
        return .just(.navigate(.setting))
    }
}
