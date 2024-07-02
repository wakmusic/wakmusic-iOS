import Foundation
import LogManager
import ReactorKit
import RxCocoa
import RxSwift
import UserDomainInterface

final class PlaylistStorageReactor: Reactor {
    enum Action {
        case viewDidLoad
        case refresh
        case itemMoved(ItemMovedEvent)
        case editButtonDidTap
        case saveButtonDidTap
        case playlistDidTap(Int)
        case tapAll(isSelecting: Bool)
    }

    enum Mutation {
        case updateDataSource([MyPlayListSectionModel])
        case switchEditingState(Bool)
        case updateOrder([PlaylistEntity])
        case changeSelectedState(data: [PlaylistEntity], selectedCount: Int)
        case changeAllState(data: [PlaylistEntity], selectedCount: Int)
    }

    struct State {
        var isEditing: Bool
        var dataSource: [MyPlayListSectionModel]
        var backupDataSource: [MyPlayListSectionModel]
        var selectedItemCount: Int
    }

    var initialState: State
    private let storageCommonService: any StorageCommonService

    init(storageCommonService: any StorageCommonService = DefaultStorageCommonService.shared) {
        self.initialState = State(
            isEditing: false,
            dataSource: [],
            backupDataSource: [],
            selectedItemCount: 0
        )

        self.storageCommonService = storageCommonService
    }

    deinit {
        LogManager.printDebug("❌ Deinit \(Self.self)")
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            updateDataSource()
        case .refresh:
            updateDataSource()
        case .editButtonDidTap:
            switchEditing(true)
        case .saveButtonDidTap:
            // TODO: USECASE 연결
            switchEditing(false)
        case let .itemMoved((sourceIndex, destinationIndex)):
            updateOrder(src: sourceIndex.row, dest: destinationIndex.row)
        case let .playlistDidTap(index):
            changeSelectingState(index)
        case let .tapAll(isSelecting):
            tapAll(isSelecting)
        }
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
        }

        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let editState = storageCommonService.isEditingState
            .map { Mutation.switchEditingState($0) }

        return Observable.merge(mutation, editState)
    }
}

extension PlaylistStorageReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .just(
            .updateDataSource(
                [MyPlayListSectionModel(
                    model: 0,
                    items: [
                    ]
                )]
            )
        )
    }

    func switchEditing(_ flag: Bool) -> Observable<Mutation> {
        return .just(.switchEditingState(flag))
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
