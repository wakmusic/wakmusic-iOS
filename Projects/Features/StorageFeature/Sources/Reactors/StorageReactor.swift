import Foundation
import ReactorKit
import UserDomainInterface
import Utility

final class StorageReactor: Reactor {
    enum Action {
        case viewDidLoad
        case switchTab(Int)
        case tabDidEditButton
        case saveButtonTap
        case showLoginAlert
        case changedUserInfo(UserInfo?)
    }

    enum Mutation {
        case updateIsLoggedIn(Bool)
        case switchTabIndex(Int)
        case switchEditingState(Bool)
        case showLoginAlert
    }

    struct State {
        var isEditing: Bool
        var tabIndex: Int
        var isLoggedIn: Bool
        @Pulse var showLoginAlert: Void?
    }

    let initialState: State
    private var disposeBag = DisposeBag()
    private let storageCommonService: any StorageCommonService
    private let fetchPlayListUseCase: any FetchPlayListUseCase
    private let editPlayListOrderUseCase: any EditPlayListOrderUseCase
    private let deletePlayListUseCase: any DeletePlayListUseCase

    init(
        storageCommonService: any StorageCommonService = DefaultStorageCommonService.shared,
        fetchPlayListUseCase: any FetchPlayListUseCase,
        editPlayListOrderUseCase: any EditPlayListOrderUseCase,
        deletePlayListUseCase: any DeletePlayListUseCase
    ) {
        initialState = State(
            isEditing: false,
            tabIndex: 0,
            isLoggedIn: false
        )
        self.storageCommonService = storageCommonService
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.editPlayListOrderUseCase = editPlayListOrderUseCase
        self.deletePlayListUseCase = deletePlayListUseCase
        observeMovedFavoriteTab()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        case let .switchTab(index):
            return switchTabIndex(index)
        case .tabDidEditButton:
            storageCommonService.isEditingState.onNext(true)
            return switchEditingState(true)
        case .showLoginAlert:
            return showLoginAlert()
        case .saveButtonTap:
            storageCommonService.isEditingState.onNext(false)
            return switchEditingState(false)
        case let .changedUserInfo(userInfo):
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateIsLoggedIn(isLoggedIn):
            newState.isLoggedIn = isLoggedIn
        case let .switchTabIndex(index):
            newState.tabIndex = index
        case let .switchEditingState(flag):
            newState.isEditing = flag
        case .showLoginAlert:
            newState.showLoginAlert = ()
        }

        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let editState = storageCommonService.isEditingState
            .map { Mutation.switchEditingState($0) }

        return Observable.merge(mutation, editState)
    }
}

private extension StorageReactor {
    func updateIsLoggedIn(_ userInfo: UserInfo?) -> Observable<Mutation> {
        return .just(.updateIsLoggedIn(userInfo != nil))
    }

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

private extension StorageReactor {
    func observeMovedFavoriteTab() {
        NotificationCenter.default.rx.notification(.movedStorageFavoriteTab)
            .bind(with: self) { owner, _ in
                owner.action.onNext(.switchTab(1))
            }
            .disposed(by: disposeBag)
    }

    func observeUserInfoChanges() {
        PreferenceManager.$userInfo
            .bind(with: self) { owner, userInfo in
                owner.action.onNext(.changedUserInfo(userInfo))
            }
            .disposed(by: disposeBag)
    }
}
