import Foundation
import PlayListDomainInterface
import ReactorKit
import RxSwift
import SongsDomainInterface

final class MyPlaylistDetailReactor: Reactor {
    enum Action {
        case viewDidLoad
        case itemDidTap(Int)
        case editButtonDidTap
        case completeButtonDidTap
        case restore
    }

    enum Mutation {
        case updateEditingState(Bool)
        case updateDataSource(MyPlaylistModel)
        case updateBackUpDataSource(MyPlaylistModel)
        case updateLoadingState(Bool)
        case updateSelectedCount(Int)
        case updateSelectingStateByIndex(MyPlaylistModel)
    }

    struct State {
        var isEditing: Bool
        var dataSource: MyPlaylistModel
        var backUpDataSource: MyPlaylistModel
        var isLoading: Bool
        var selectedCount: Int
    }

    var initialState: State
    #warning("추후 usecase 연결")

    init() {
        self.initialState = State(
            isEditing: false,
            dataSource: MyPlaylistModel(PlayListDetailEntity(
                key: "000",
                title: "임시플레이리스트 입니다.",
                songs: [],
                image: "",
                private: true
            )), backUpDataSource: MyPlaylistModel(PlayListDetailEntity(
                key: "000",
                title: "임시플레이리스트 입니다.",
                songs: [],
                image: "",
                private: true
            )),
            isLoading: false,
            selectedCount: 0
        )
    }

    #warning("추후 usecase 연결 후 갱신")
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()
        case .editButtonDidTap:
            return beginEditing()

        case .completeButtonDidTap:
            return endEditing()

        case let .itemDidTap(index):
            return updateItemSelected(index)
        case .restore:
            return restoreDataSource()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateEditingState(flag):
            newState.isEditing = flag

        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource

        case let .updateBackUpDataSource(dataSource):
            newState.backUpDataSource = dataSource

        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        case let .updateSelectedCount(count):
            newState.selectedCount = count

        case let .updateSelectingStateByIndex(dataSource):
            newState.dataSource = dataSource
        }

        return newState
    }
}

private extension MyPlaylistDetailReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            .just(.updateDataSource(MyPlaylistModel(PlayListDetailEntity(
                key: "0034",
                title: "임시플레이리스트 입니다.",
                songs: fetchData(),
                image: "",
                private: true
            )))),
            .just(.updateLoadingState(false))
        ])
    }

    func beginEditing() -> Observable<Mutation> {
        let state = currentState
        let currentDataSoruce = state.dataSource

        return .concat([
            .just(.updateEditingState(true)),
            .just(.updateBackUpDataSource(currentDataSoruce))
        ])
    }

    func endEditing() -> Observable<Mutation> {
        #warning("저장 유즈 케이스")
        let state = currentState
        var currentDataSoruce = state.dataSource.data

        for i in 0 ..< currentDataSoruce.songs.count {
            currentDataSoruce.songs[i].isSelected = false
        }

        return .concat([
            .just(.updateEditingState(false)),
            .just(.updateDataSource(MyPlaylistModel(currentDataSoruce))),
            .just(.updateBackUpDataSource(MyPlaylistModel(currentDataSoruce)))
        ])
    }

    func updateItemSelected(_ index: Int) -> Observable<Mutation> {
        let state = currentState
        var count = state.selectedCount
        var prev = state.dataSource.data

        if prev.songs[index].isSelected {
            count -= 1
        } else {
            count += 1
        }
        prev.songs[index].isSelected = !prev.songs[index].isSelected

        return .concat([
            .just(Mutation.updateSelectedCount(count)),
            .just(Mutation.updateSelectingStateByIndex(MyPlaylistModel(prev)))
        ])
    }

    func restoreDataSource() -> Observable<Mutation> {
        let state = currentState
        let backUpDataSource = state.backUpDataSource

        return .concat([
            .just(Mutation.updateEditingState(false)),
            .just(Mutation.updateDataSource(backUpDataSource))
        ])
    }
}

func fetchData() -> [SongEntity] {
    return [
        SongEntity(
            id: "8KTFf2X-ago",
            title: "Another World",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "w53y9AchWtI",
            title: "그대의 시간을 위해 (ft. 비밀소녀, 팬치) (기동전함 왁데시코 ED)",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "TKNWBrnXCT0",
            title: "Superhero (ft. 우왁굳)",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "H500rMdazVc",
            title: "왁차지껄",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "H500rMdazVc1",
            title: "왁차지껄",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "H500rMdazVc2",
            title: "왁차지껄",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "H500rMdazVc3",
            title: "왁차지껄",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "H500rMdazVc4",
            title: "왁차지껄",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        ),
        SongEntity(
            id: "H500rMdazVc5",
            title: "왁차지껄",
            artist: "이세계아이돌",
            remix: "",
            reaction: "",
            views: 3,
            last: 0,
            date: "2012.12.12"
        )
    ]
}
