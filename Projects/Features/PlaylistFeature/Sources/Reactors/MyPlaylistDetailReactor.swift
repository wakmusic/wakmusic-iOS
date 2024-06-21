import Foundation
import PlayListDomainInterface
import ReactorKit
import RxSwift
import SongsDomainInterface

final class MyPlaylistDetailReactor: Reactor {
    enum Action {
        case viewDidLoad
        case changeEditingState
    }

    enum Mutation {
        case updateEditingState
        case updateDataSource(PlayListDetailEntity)
        case updateLoadingState(Bool)
    }

    struct State {
        var isEditing: Bool
        var dataSource: PlayListDetailEntity
        var isLoading: Bool
        var selectedCount: Int
    }

    var initialState: State
    #warning("추후 usecase 연결")

    init() {
        self.initialState = State(
            isEditing: false,
            dataSource: PlayListDetailEntity(
                key: "000",
                title: "임시플레이리스트 입니다.",
                songs: [],
                image: "",
                private: true
            ),
            isLoading: false,
            selectedCount: 0
        )
    }

    #warning("추후 usecase 연결 후 갱신")
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()
        case .changeEditingState:
            return .just(.updateEditingState)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .updateEditingState:
            newState.isEditing = !newState.isEditing

        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}

extension MyPlaylistDetailReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            .just(.updateDataSource(PlayListDetailEntity(
                key: "0034",
                title: "임시플레이리스트 입니다.",
                songs: [SongEntity(
                    id: "8KTFf2X-ago",
                    title: "Another World",
                    artist: "이세계아이돌",
                    remix: "",
                    reaction: "",
                    views: 3,
                    last: 0,
                    date: "2012.12.12"
                )],
                image: "",
                private: true
            ))),
            .just(.updateLoadingState(false))
        ])
    }
}
