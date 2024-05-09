import BaseFeature
import Foundation
import LogManager
import ReactorKit
import RxRelay
import RxSwift
import Utility

final class SearchReactor: Reactor {
    var disposeBag: DisposeBag = DisposeBag()

    enum Action {
        case switchTypingState(TypingStatus)
        case updateText(String)
        case cancel
        case search
    }

    enum Mutation {
        case updateTypingState(state: TypingStatus)
        case updateText(String)
    }

    struct State {
        var typingState: TypingStatus
        var text: String
    }

    var initialState: State

    init() {
        self.initialState = State(
            typingState: .before,
            text: ""
        )
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self) deinit")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .switchTypingState(state):
            updateTypingState(state)
        case .cancel:
            updateTypingState(.before)
        case let .updateText(text):
            updateText(text)
        case .search:
            updateTypingState(.search)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateTypingState(state):
            newState.typingState = state
        case let .updateText(text):
            newState.text = text
        }

        return newState
    }


}

fileprivate extension SearchReactor {
    func updateTypingState(_ state: TypingStatus) -> Observable<Mutation> {
        return .just(.updateTypingState(state: state))
    }

    func updateText(_ text: String) -> Observable<Mutation> {
        return .just(.updateText(text))
    }
}
