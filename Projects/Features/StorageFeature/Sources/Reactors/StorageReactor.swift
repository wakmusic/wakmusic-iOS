import Foundation
import ReactorKit
import Utility

final class StorageReactor: Reactor {

    enum Action {
        case switchTab(Int)
        case tabDidEditButton
        case saveButtonTap
        case showLoginAlert
    }

    enum Mutation {
        
        case switchTabIndex(Int)
        case switchEditingState(Bool)
        case showLoginAlert
        
    }

    struct State {
        var isEditing: Bool
        var tabIndex: Int
        @Pulse var isShowLoginAlert: Void
    }

    let initialState: State

    init() {
        initialState = State(
            isEditing: false,
            tabIndex: 0,
            isShowLoginAlert: ()
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
        case let .switchTab(index):
            return switchTabIndex(index)
        case let .tabDidEditButton:
            return switchEditingState(true)
        case .showLoginAlert:
            return showLoginAlert()
        case .saveButtonTap:
            return switchEditingState(false)
        }
        
        
    }

    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
            
        case let .switchTabIndex(index):
            newState.tabIndex = index
        case let .switchEditingState(flag):
            newState.isEditing = flag
        case .showLoginAlert:
            newState.isShowLoginAlert = ()
        }
        
        return newState
        
    }
    
}

extension StorageReactor {
    
    func switchTabIndex(_ index: Int) -> Observable<Mutation> {
        return .just(.switchTabIndex(index))
    }
    
    func switchEditingState(_ flag: Bool) -> Observable<Mutation> {
        
        return .just(.switchEditingState(flag))
    }
    
    func showLoginAlert() -> Observable<Mutation> {
        return .just(.showLoginAlert)
    }
    
}
