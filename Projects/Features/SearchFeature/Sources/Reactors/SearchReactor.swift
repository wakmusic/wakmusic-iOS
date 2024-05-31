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
        case cancelButtonDidTap
    }

    enum Mutation {
        case updateTypingState(state: TypingStatus)
        case updateText(String)
        case fetchRecentText(String)
    }

    struct State {
        var typingState: TypingStatus
        var text: String
    }

    var initialState: State
    private let service: any SearchCommonService
    init(service: any SearchCommonService = DefaultSearchCommonService.shared) {
        self.service = service
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
        case .cancelButtonDidTap:
            updateTypingState(.before)
        case let .updateText(text):
            updateText(text)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateTypingState(state):
            newState.typingState = state
        case let .updateText(text):
            newState.text = text
        case let .fetchRecentText(text):
            break
        }

        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let servicetypingState = DefaultSearchCommonService.shared.typingStatus.map{Mutation.updateTypingState(state: $0)}
        
        let text = DefaultSearchCommonService.shared.recentText.map{Mutation.updateText($0)}
        
        return Observable.merge(mutation,servicetypingState,text)
        
        
    }
}

fileprivate extension SearchReactor {
    func updateTypingState(_ state: TypingStatus) -> Observable<Mutation> {
        
        service.typingStatus.onNext(state)
        
        return .just(.updateTypingState(state: state))
    }

    func updateText(_ text: String) -> Observable<Mutation> {
        return .just(.updateText(text))
    }
    
    
}
