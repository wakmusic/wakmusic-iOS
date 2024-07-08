import Foundation
import LogManager
import ReactorKit
import RxCocoa
import RxSwift
import UserDomainInterface

final class ListStorageReactor: Reactor {
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
        case updateOrder([PlayListEntity])
        case changeSelectedState(data: [PlayListEntity], selectedCount: Int)
        case changeAllState(data: [PlayListEntity], selectedCount: Int)
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

extension ListStorageReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .just(
            .updateDataSource(
                [MyPlayListSectionModel(
                    model: 0,
                    items: [
                        .init(
                            key: "123",
                            title: "우중충한 장마철 여름에 듣기 좋은 일본 시티팝 플레이리스트",
                            image: "",
                            songlist: [],
                            image_version: 0
                        ),
                        .init(
                            key: "1234",
                            title: "비내리는 도시, 세련된 무드 감각적인 팝송☔️ 분위기 있는 노래 모음",
                            image: "",
                            songlist: [],
                            image_version: 0
                        ),
                        .init(
                            key: "1234",
                            title: "[𝐏𝐥𝐚𝐲𝐥𝐢𝐬𝐭] 여름 밤, 퇴근길에 꽂는 플레이리스트🚃",
                            image: "",
                            songlist: [],
                            image_version: 0
                        ),
                        .init(
                            key: "1234",
                            title: "𝐏𝐥𝐚𝐲𝐥𝐢𝐬𝐭 벌써 여름이야? 내 방을 청량한 캘리포니아 해변으로 신나는 여름 팝송 𝐒𝐮𝐦𝐦𝐞𝐫 𝐢𝐬 𝐜𝐨𝐦𝐢𝐧𝐠 🌴",
                            image: "",
                            songlist: [],
                            image_version: 0
                        )
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
