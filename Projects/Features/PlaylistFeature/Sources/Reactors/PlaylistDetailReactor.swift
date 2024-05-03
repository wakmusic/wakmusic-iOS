import AuthDomainInterface
import BaseDomainInterface
import BaseFeature
import ErrorModule
import Foundation
import PlayListDomainInterface
import ReactorKit
import RxCocoa
import RxRelay
import RxSwift
import SongsDomainInterface
import Utility

internal final class PlaylistDetailReactor: Reactor {
    enum Action {
        case viewDidLoad
        case itemMoved(ItemMovedEvent)
        case tapEdit
        case save
        case tapSong(Int)
        case tapAll(isSelecting: Bool)
        case undo
    }

    enum Mutation {
        case fetchData(PlaylistMetaData)
        case updateOrder([SongEntity])
        case changeSelectedState(data: [SongEntity], selectedCount: Int)
        case changeAllState(data: [SongEntity], selectedCount: Int)
        case updateDataSource(data: [PlayListDetailSectionModel])
        case updateIsEditing(Bool)
    }

    struct State {
        var dataSource: [PlayListDetailSectionModel]
        var backupDataSource: [PlayListDetailSectionModel]
        var header: PlayListHeaderModel
        var selectedItemCount: Int
        var isEditing: Bool
    }

    internal var initialState: State
    internal let type: PlayListType
    private var disposeBag = DisposeBag()
    internal let key: String
    private let fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase
    private let editPlayListUseCase: any EditPlayListUseCase
    private let removeSongsUseCase: any RemoveSongsUseCase
    private let logoutUseCase: any LogoutUseCase

    public init(
        key: String,
        type: PlayListType,
        fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase,
        editPlayListUseCase: any EditPlayListUseCase,
        removeSongsUseCase: any RemoveSongsUseCase,
        logoutUseCase: any LogoutUseCase
    ) {
        self.key = key
        self.type = type
        self.fetchPlayListDetailUseCase = fetchPlayListDetailUseCase
        self.editPlayListUseCase = editPlayListUseCase
        self.removeSongsUseCase = removeSongsUseCase
        self.logoutUseCase = logoutUseCase
        self.initialState = .init(
            dataSource: [],
            backupDataSource: [],
            header: PlayListHeaderModel(
                title: "",
                songCount: "",
                image: "",
                version: 0
            ),
            selectedItemCount: 0,
            isEditing: false
        )
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchData()
        case let .itemMoved((sourceIndex, destinationIndex)):
            return updateOrder(src: sourceIndex.row, dest: destinationIndex.row)

        case .tapEdit:
            return updateIsEditing(true)

        case .save:
            return .concat(
                updateIsEditing(false),
                updateDataSource(false),
                saveData()
            )
        case let .tapSong(index):
            return changeSelectingState(index)
        case let .tapAll(flag):
            return tapAll(flag)
        case .undo:
            return .concat(
                updateIsEditing(false),
                updateDataSource(true)
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateOrder(data):
            newState.dataSource = [PlayListDetailSectionModel(model: 0, items: data)]

        case let .fetchData(metadata):
            newState.backupDataSource = metadata.list
            newState.dataSource = metadata.list
            newState.header = metadata.header

        case let .changeSelectedState((data, count)), let .changeAllState((data, count)):
            newState.dataSource = [PlayListDetailSectionModel(model: 0, items: data)]
            newState.selectedItemCount = count

        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
            newState.backupDataSource = dataSource

        case let .updateIsEditing(flag):
            newState.isEditing = flag
        }

        return newState
    }
}

// MARK: - Mutate

private extension PlaylistDetailReactor {
    /// 서버에서 데이터 불러오기
    func fetchData() -> Observable<Mutation> {
        return fetchPlayListDetailUseCase.execute(id: key, type: type)
            .catchAndReturn(
                PlayListDetailEntity(
                    key: key,
                    title: "",
                    songs: [],
                    image: "",
                    image_square_version: 0,
                    image_round_version: 0,
                    version: 0
                )
            )
            .asObservable()
            .map { [weak self] result in

                guard let self else {
                    return PlaylistMetaData(
                        list: [],
                        header: PlayListHeaderModel(title: "", songCount: "", image: "", version: 0)
                    )
                }
                return PlaylistMetaData(
                    list: [PlayListDetailSectionModel(model: 0, items: result.songs)],
                    header: PlayListHeaderModel(
                        title: result.title,
                        songCount: "\(result.songs.count)곡",
                        image: self.type == .wmRecommend ? result.key : result.image,
                        version: self.type == .wmRecommend ? result.image_square_version : result.version
                    )
                )
            }
            .map(Mutation.fetchData)
    }

    // 데이터 업데이트

    func updateDataSource(_ isBackup: Bool) -> Observable<Mutation> {
        let tmp = isBackup ? currentState.backupDataSource : currentState.dataSource

        return .just(.updateDataSource(data: tmp))
    }

    func updateIsEditing(_ flag: Bool) -> Observable<Mutation> {
        return .just(.updateIsEditing(flag))
    }

    /// 순서 변경
    func updateOrder(src: Int, dest: Int) -> Observable<Mutation> {
        var tmp = (currentState.dataSource.first ?? PlayListDetailSectionModel(model: 0, items: [])).items
        let target = tmp[src]
        tmp.remove(at: src)
        tmp.insert(target, at: dest)
        return .just(.updateOrder(tmp))
    }

    /// 저장(서버) , 따로 패치는 안한다 ..
    func saveData() -> Observable<Mutation> {
        let dataSource = currentState.dataSource.first?.items.map { $0.id } ?? []
        let backupDataSource = currentState.backupDataSource.first?.items.map { $0.id } ?? []

        if dataSource.elementsEqual(backupDataSource) {
            return .empty()
        }

        return editPlayListUseCase
            .execute(key: key, songs: dataSource)
            .asObservable()
            .do(onNext: { _ in
                NotificationCenter.default.post(name: .playListRefresh, object: nil)
            })
            .flatMap { _ in Observable.empty() }
    }

    /// 단일 곡 선택 상태 변경
    func changeSelectingState(_ index: Int) -> Observable<Mutation> {
        // TODO: 로그 찍기 ,  LogManager.printError("playlist detail datasource is empty")
        guard var tmp = currentState.dataSource.first?.items else {
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
        var tmp = (currentState.dataSource.first ?? PlayListDetailSectionModel(model: 0, items: [])).items
        let count = flag ? tmp.count : 0

        for i in 0 ..< tmp.count {
            tmp[i].isSelected = flag
        }
        return .just(.changeAllState(data: tmp, selectedCount: count))
    }
}
