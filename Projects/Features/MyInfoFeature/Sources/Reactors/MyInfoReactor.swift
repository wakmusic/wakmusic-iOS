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
        case faqNavigationDidTap
        case notiNavigationDidTap
        case mailNavigationDidTap
        case teamNavigationDidTap
        case settingNavigationDidTap
    }

    enum Mutation {
        case loginButtonDidTap
        case moreButtonDidTap
        case drawButtonDidTap
        case likeNavigationDidTap
        case faqNavigationDidTap
        case notiNavigationDidTap
        case mailNavigationDidTap
        case teamNavigationDidTap
        case settingNavigationDidTap
    }

    struct State {
        var userInfo: UserInfo?
        @Pulse var loginButtonDidTap: Bool?
        @Pulse var moreButtonDidTap: Bool?
        @Pulse var drawButtonDidTap: Bool?
        @Pulse var likeNavigationDidTap: Bool?
        @Pulse var faqNavigationDidTap: Bool?
        @Pulse var notiNavigationDidTap: Bool?
        @Pulse var mailNavigationDidTap: Bool?
        @Pulse var teamNavigationDidTap: Bool?
        @Pulse var settingNavigationDidTap: Bool?
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
        case .faqNavigationDidTap:
            return faqNavigationDidTap()
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

        case .drawButtonDidTap:
            newState.drawButtonDidTap = true

        case .likeNavigationDidTap:
            newState.likeNavigationDidTap = true

        case .faqNavigationDidTap:
            newState.faqNavigationDidTap = true

        case .notiNavigationDidTap:
            newState.notiNavigationDidTap = true

        case .mailNavigationDidTap:
            newState.mailNavigationDidTap = true

        case .teamNavigationDidTap:
            newState.teamNavigationDidTap = true

        case .settingNavigationDidTap:
            newState.settingNavigationDidTap = true
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
        return .just(.drawButtonDidTap)
    }

    func likeNavigationDidTap() -> Observable<Mutation> {
        return .just(.likeNavigationDidTap)
    }

    func faqNavigationDidTap() -> Observable<Mutation> {
        return .just(.faqNavigationDidTap)
    }

    func notiNavigationDidTap() -> Observable<Mutation> {
        return .just(.notiNavigationDidTap)
    }

    func mailNavigationDidTap() -> Observable<Mutation> {
        return .just(.mailNavigationDidTap)
    }

    func teamNavigationDidTap() -> Observable<Mutation> {
        return .just(.teamNavigationDidTap)
    }

    func settingNavigationDidTap() -> Observable<Mutation> {
        return .just(.settingNavigationDidTap)
    }
}
