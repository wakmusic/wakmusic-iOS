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
        case itemMoved
    }

    public enum Mutation {
        case itemMoved(ItemMovedEvent)
        case updateData(PlaylistMetaData)
        case startEditing
        case cancelEditing
    }

    public struct State {
        var dataSource: [PlayListDetailSectionModel]
        var backupDataSource: [PlayListDetailSectionModel]
        var header: PlayListHeader
        var selectedItemCount: Int
    }

    public var initialState: State
    private let type: PlayListType!
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
            dataSource: [], backupDataSource: [], header: PlayListHeader(
                title: "",
                songCount: "",
                image: "",
                version: 0
            ), selectedItemCount: 0
        )
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchData()

        case .itemMoved:
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .itemMoved((sourceIndex, destinationIndex)): // TODO: remove insert
            break
        case let .updateData(metadata):
            newState.backupDataSource = metadata.list
            newState.dataSource = metadata.list
            newState.header = metadata.header

        case .startEditing: break

        case .cancelEditing: break
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
            .map(Mutation.updateData)
    }
}
