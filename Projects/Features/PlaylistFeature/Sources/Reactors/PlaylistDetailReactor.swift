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

public final class PlaylistDetailReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case itemMoved(ItemMovedEvent)
        case tapEdit
        case completeEdit
        case tapSong(Int)
    }

    public enum Mutation {
        case fetchData(PlaylistMetaData)
        case updateOrder([SongEntity])
        case beginEdit
        case save
        case changeSelectedState(([SongEntity],Int))
    }

    public struct State {
        var dataSource: [PlayListDetailSectionModel]
        var backupDataSource: [PlayListDetailSectionModel]
        var header: PlayListHeader
        var selectedItemCount: Int
        var isEditing: Bool
    }

    public var initialState: State
    public let type: PlayListType!
    private let key: String!
    private let fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase
    private let editPlayListUseCase: any EditPlayListUseCase
    private let removeSongsUseCase: any RemoveSongsUseCase
    private let logoutUseCase: any LogoutUseCase
    var disposeBag = DisposeBag()

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
            header: PlayListHeader(
                title: "",
                songCount: "",
                image: "",
                version: 0
            ), selectedItemCount: 0,
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
            return .just(Mutation.beginEdit)

        case .completeEdit:
            return saveData()
        case let .tapSong(index):
            return changeSelectingState(index)
            
            
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateOrder(data):
            newState.dataSource = [PlayListDetailSectionModel(model: 0, items: data)]

        case let .fetchData(metadata):
            newState.backupDataSource = metadata.list
            newState.dataSource = metadata.list
            newState.header = metadata.header

        case .beginEdit:
            newState.isEditing = true
        case .save:
            newState.isEditing = false
        case let  .changeSelectedState((data, count)):
            newState.dataSource = [PlayListDetailSectionModel(model: 0, items: data)]
            newState.selectedItemCount = count
        }

        return newState
    }
}

// MARK: - Mutate

private extension PlaylistDetailReactor {
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
                        header: PlayListHeader(title: "", songCount: "", image: "", version: 0)
                    )
                }
                return PlaylistMetaData(
                    list: [PlayListDetailSectionModel(model: 0, items: result.songs)],
                    header: PlayListHeader(
                        title: result.title,
                        songCount: "\(result.songs.count)곡",
                        image: self.type == .wmRecommend ? result.key : result.image,
                        version: self.type == .wmRecommend ? result.image_square_version : result.version
                    )
                )
            }
            .map(Mutation.fetchData)
    }

    func updateOrder(src: Int, dest: Int) -> Observable<Mutation> {
        var tmp = (currentState.dataSource.first ?? PlayListDetailSectionModel(model: 0, items: [])).items
        let target = tmp[src]
        tmp.remove(at: src)
        tmp.insert(target, at: dest)
        return .just(.updateOrder(tmp))
    }

    func saveData() -> Observable<Mutation> {
        let dataSource = currentState.dataSource[0].items.map { $0.id }
        let backupDataSource = currentState.backupDataSource[0].items.map { $0.id }

        if dataSource.elementsEqual(backupDataSource) {
            return .empty()
        }

        return editPlayListUseCase
            .execute(key: key, songs: dataSource)
            .asObservable()
            .map{_ in .save}
        
        
        // 여기서 새로운 데이터 패치 해야하는데 ??
    }
    func changeSelectingState(_ index: Int) -> Observable<Mutation> {
        var tmp = (currentState.dataSource.first ?? PlayListDetailSectionModel(model: 0, items: [])).items
        var count = currentState.selectedItemCount
        let target = tmp[index]
        count = target.isSelected ? count-1 : count+1
        tmp[index].isSelected = !tmp[index].isSelected
        return .just(.changeSelectedState((tmp, count)))
    }
}
