import Foundation
import LogManager
import ReactorKit
import Utility

final class TeamInfoReactor: Reactor {
    enum Action {
        case dismissButtonDidTap
    }

    enum Mutation {
        case dismissButtonDidTap
    }

    struct State {
        @Pulse var dismissButtonDidTap: Bool?
    }

    var initialState: State
    private var disposeBag = DisposeBag()

    init() {
        self.initialState = .init()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dismissButtonDidTap:
            return dismissButtonDidTap()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .dismissButtonDidTap:
            newState.dismissButtonDidTap = true
        }
        return newState
    }
}

private extension TeamInfoReactor {
    func dismissButtonDidTap() -> Observable<Mutation> {
        return .just(.dismissButtonDidTap)
    }
}
