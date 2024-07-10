import Foundation
import LogManager
import PlaylistDomainInterface
import ReactorKit
import RxCocoa
import RxSwift
import UserDomainInterface
import Utility

final class ListStorageReactor: Reactor {
    enum Action {
        case viewDidLoad
        case refresh
        case itemMoved(ItemMovedEvent)
        case createListButtonDidTap
        case playlistDidTap(Int)
        case tapAll(isSelecting: Bool)
        case loginButtonDidTap
    }

    enum Mutation {
        case clearDataSource
        case updateDataSource([MyPlayListSectionModel])
        case updateBackupDataSource
        case undoDateSource
        case switchEditingState(Bool)
        case updateOrder([PlayListEntity])
        case changeSelectedState(data: [PlayListEntity], selectedCount: Int)
        case changeAllState(data: [PlayListEntity], selectedCount: Int)
        case updateIsLoggedIn(Bool)
        case updateIsShowActivityIndicator(Bool)
        case showLoginAlert
        case showToast(String)
    }

    struct State {
        var isLoggedIn: Bool
        var isEditing: Bool
        var dataSource: [MyPlayListSectionModel]
        var backupDataSource: [MyPlayListSectionModel]
        var selectedItemCount: Int
        var isShowActivityIndicator: Bool
        @Pulse var showLoginAlert: Void?
        @Pulse var showToast: String?
    }

    var initialState: State
    private var disposeBag = DisposeBag()
    private let storageCommonService: any StorageCommonService
    private let createPlaylistUseCase: any CreatePlaylistUseCase
    private let fetchPlayListUseCase: any FetchPlayListUseCase
    private let editPlayListOrderUseCase: any EditPlayListOrderUseCase
    private let deletePlayListUseCase: any DeletePlayListUseCase

    init(
        storageCommonService: any StorageCommonService = DefaultStorageCommonService.shared,
        createPlaylistUseCase: any CreatePlaylistUseCase,
        fetchPlayListUseCase: any FetchPlayListUseCase,
        editPlayListOrderUseCase: any EditPlayListOrderUseCase,
        deletePlayListUseCase: any DeletePlayListUseCase
    ) {
        self.initialState = State(
            isLoggedIn: false,
            isEditing: false,
            dataSource: [],
            backupDataSource: [],
            selectedItemCount: 0,
            isShowActivityIndicator: false
        )
        self.storageCommonService = storageCommonService
        self.createPlaylistUseCase = createPlaylistUseCase
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.editPlayListOrderUseCase = editPlayListOrderUseCase
        self.deletePlayListUseCase = deletePlayListUseCase
    }

    deinit {
        LogManager.printDebug("❌ Deinit \(Self.self)")
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.updateIsShowActivityIndicator(true)),
                fetchDataSource(),
                .just(.updateIsShowActivityIndicator(false))
            )
        case .refresh:
            return fetchDataSource()
        case let .itemMoved((sourceIndex, destinationIndex)):
            return updateOrder(src: sourceIndex.row, dest: destinationIndex.row)
        case let .playlistDidTap(index):
            return changeSelectingState(index)
        case let .tapAll(isSelecting):
            return tapAll(isSelecting)
        case .createListButtonDidTap:
            return .empty()
        case .loginButtonDidTap:
            return .just(.showLoginAlert)
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let switchEditingStateMutation = storageCommonService.isEditingState
            .skip(1)
            .withUnretained(self)
            .flatMap { owner, editingState -> Observable<Mutation> in
                // 편집이 종료될 때 처리
                if editingState == false {
                    return .concat(
                        .just(.updateIsShowActivityIndicator(true)),
                        owner.mutateEditPlayListOrderUseCase(),
                        .just(.updateIsShowActivityIndicator(false)),
                        .just(.switchEditingState(false))
                    )
                } else {
                    return .just(.switchEditingState(editingState))
                }
            }

        let changedUserInfoMutation = storageCommonService.changedUserInfoEvent
            .withUnretained(self)
            .flatMap { owner, userInfo -> Observable<Mutation> in
                .concat(
                    owner.updateIsLoggedIn(userInfo),
                    owner.fetchDataSource()
                )
            }

        return Observable.merge(mutation, switchEditingStateMutation, changedUserInfoMutation)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
            newState.backupDataSource = dataSource
        case let .switchEditingState(flag):
            newState.isEditing = flag
        case let .updateOrder(dataSource):
            newState.dataSource = [MyPlayListSectionModel(model: 0, items: dataSource)]
        case let .changeSelectedState(data: data, selectedCount: selectedCount):
            newState.dataSource = [MyPlayListSectionModel(model: 0, items: data)]
            newState.selectedItemCount = selectedCount
        case let .changeAllState(data: data, selectedCount: selectedCount):
            newState.dataSource = [MyPlayListSectionModel(model: 0, items: data)]
            newState.selectedItemCount = selectedCount
        case .clearDataSource:
            newState.dataSource = []
        case let .updateIsLoggedIn(isLoggedIn):
            newState.isLoggedIn = isLoggedIn
        case .showLoginAlert:
            newState.showLoginAlert = ()
        case let .updateIsShowActivityIndicator(isShow):
            newState.isShowActivityIndicator = isShow
        case .undoDateSource:
            newState.dataSource = currentState.backupDataSource
        case .updateBackupDataSource:
            newState.backupDataSource = currentState.dataSource
        case let .showToast(message):
            newState.showToast = message
        }

        return newState
    }
}

extension ListStorageReactor {
    func fetchDataSource() -> Observable<Mutation> {
        fetchPlayListUseCase
            .execute()
            .catchAndReturn([])
            .asObservable()
            .map { [MyPlayListSectionModel(model: 0, items: $0)] }
            .map { Mutation.updateDataSource($0) }
    }

    func updateIsLoggedIn(_ userInfo: UserInfo?) -> Observable<Mutation> {
        return .just(.updateIsLoggedIn(userInfo != nil))
    }

    func clearDataSource() -> Observable<Mutation> {
        print("🚀 clearDataSource called Reactor")
        return .just(.clearDataSource)
    }
    
    func mutateEditPlayListOrderUseCase() -> Observable<Mutation> {
        let playlistOrder = currentState.dataSource.flatMap { $0.items.map { $0.key } }
        return editPlayListOrderUseCase.execute(ids: playlistOrder)
                .asObservable()
                .flatMap { _ -> Observable<Mutation> in
                    return Observable.concat([
                        .just(.updateBackupDataSource)
                    ])
                }
                .catch { error in
                    let error = error.asWMError
                    return Observable.concat([
                        .just(.undoDateSource),
                        .just(.showToast(error.errorDescription ?? "순서 변경에 실패했습니다."))
                    ])
                }
    }

    /// 순서 변경
    func updateOrder(src: Int, dest: Int) -> Observable<Mutation> {
        guard var tmp = currentState.dataSource.first?.items else {
            LogManager.printError("playlist datasource is empty")
            return .empty()
        }

        let target = tmp[src]
        tmp.remove(at: src)
        tmp.insert(target, at: dest)
        return .just(.updateOrder(tmp))
    }

    func changeSelectingState(_ index: Int) -> Observable<Mutation> {
        guard var tmp = currentState.dataSource.first?.items else {
            LogManager.printError("playlist datasource is empty")
            return .empty()
        }

        var count = currentState.selectedItemCount
        let target = tmp[index]
        count = target.isSelected ? count - 1 : count + 1
        tmp[index].isSelected = !tmp[index].isSelected
        return .just(.changeSelectedState(data: tmp, selectedCount: count))
    }

    /// 전체 곡 선택 / 해제
    func tapAll(_ flag: Bool) -> Observable<Mutation> {
        guard var tmp = currentState.dataSource.first?.items else {
            LogManager.printError("playlist datasource is empty")
            return .empty()
        }

        let count = flag ? tmp.count : 0

        for i in 0 ..< tmp.count {
            tmp[i].isSelected = flag
        }
        return .just(.changeAllState(data: tmp, selectedCount: count))
    }
}
