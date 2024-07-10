import Foundation
import ReactorKit
import UserDomainInterface
import Utility

final class StorageReactor: Reactor {
    enum Action {
        case viewDidLoad
        case switchTab(Int)
        case editButtonDidTap
        case saveButtonTap
    }

    enum Mutation {
        case switchTabIndex(Int)
        case switchEditingState(Bool)
    }

    struct State {
        var isEditing: Bool
        var tabIndex: Int
    }

    let initialState: State
    private var disposeBag = DisposeBag()
    private let storageCommonService: any StorageCommonService
    
    init(
        storageCommonService: any StorageCommonService = DefaultStorageCommonService.shared
    ) {
        initialState = State(
            isEditing: false,
            tabIndex: 0
        )
        self.storageCommonService = storageCommonService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        case let .switchTab(index):
            return switchTabIndex(index)
        case .editButtonDidTap:
            storageCommonService.isEditingState.onNext(true)
            return switchEditingState(true)
        case .saveButtonTap:
            storageCommonService.isEditingState.onNext(false)
            return switchEditingState(false)
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let editState = storageCommonService.isEditingState
            .map { Mutation.switchEditingState($0) }
        
        let movedLikeStorageEvent = storageCommonService.movedLikeStorageEvent
            .map { _ in Mutation.switchTabIndex(1) }
        
        return Observable.merge(mutation, editState, movedLikeStorageEvent)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .switchTabIndex(index):
            newState.tabIndex = index
        case let .switchEditingState(flag):
            newState.isEditing = flag
        }

        return newState
    }

    
}

private extension StorageReactor {
    func switchTabIndex(_ index: Int) -> Observable<Mutation> {
        return .just(.switchTabIndex(index))
    }

    func switchEditingState(_ flag: Bool) -> Observable<Mutation> {
        return .just(.switchEditingState(flag))
    }
}
