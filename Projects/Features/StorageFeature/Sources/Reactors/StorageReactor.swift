import Foundation
import LogManager
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
        case updateIsLoggedIn(Bool)
        case switchTabIndex(Int)
        case switchEditingState(Bool)
        case showLoginAlert(CommonAnalyticsLog.LoginButtonEntry)
    }

    struct State {
        var isLoggedIn: Bool
        var isEditing: Bool
        var tabIndex: Int
        @Pulse var showLoginAlert: CommonAnalyticsLog.LoginButtonEntry?
    }

    let initialState: State
    private var disposeBag = DisposeBag()
    private let storageCommonService: any StorageCommonService

    init(
        storageCommonService: any StorageCommonService
    ) {
        initialState = State(
            isLoggedIn: false,
            isEditing: false,
            tabIndex: 0
        )
        self.storageCommonService = storageCommonService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        case let .switchTab(index):
            return switchTabIndex(index)
        case .editButtonDidTap:
            if currentState.isLoggedIn {
                storageCommonService.isEditingState.onNext(true)
                return switchEditingState(true)
            } else {
                return .just(.showLoginAlert(.myPlaylist))
            }
        case .saveButtonTap:
            storageCommonService.isEditingState.onNext(false)
            return switchEditingState(false)
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let switchEditingStateMutation = storageCommonService.isEditingState
            .map { Mutation.switchEditingState($0) }

        let updateIsLoggedInMutation = storageCommonService.loginStateDidChangedEvent
            .flatMap { userID -> Observable<Mutation> in
                let isLoggedIn = userID != nil
                return .just(.updateIsLoggedIn(isLoggedIn))
            }

        return Observable.merge(
            mutation,
            switchEditingStateMutation,
            updateIsLoggedInMutation
        )
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .switchTabIndex(index):
            newState.tabIndex = index
        case let .switchEditingState(flag):
            newState.isEditing = flag
        case let .showLoginAlert(entry):
            newState.showLoginAlert = entry
        case let .updateIsLoggedIn(isLoggedIn):
            newState.isLoggedIn = isLoggedIn
        }

        return newState
    }
}

private extension StorageReactor {
    func viewDidLoad() -> Observable<Mutation> {
        let isLoggedIn = PreferenceManager.userInfo != nil
        return .just(.updateIsLoggedIn(isLoggedIn))
    }

    func switchTabIndex(_ index: Int) -> Observable<Mutation> {
        return .just(.switchTabIndex(index))
    }

    func switchEditingState(_ flag: Bool) -> Observable<Mutation> {
        return .just(.switchEditingState(flag))
    }
}
