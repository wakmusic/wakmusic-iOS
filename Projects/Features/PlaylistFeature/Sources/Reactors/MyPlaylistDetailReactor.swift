import AuthDomainInterface
import Foundation
import PlaylistDomainInterface
import ReactorKit
import RxSwift
import SongsDomainInterface
import Utility

final class MyPlaylistDetailReactor: Reactor {
    let key: String

    enum Action {
        case viewDidLoad
        case itemDidTap(Int)
        case editButtonDidTap
        case privateButtonDidTap
        case completeButtonDidTap
        case restore
        case itemDidMoved(Int, Int)
        case forceSave
        case changeTitle(String)
        case selectAll
        case deselectAll
        case removeSongs
    }

    enum Mutation {
        case updateEditingState(Bool)
        case updateHeader(MyPlaylistHeaderModel)
        case updateDataSource([SongEntity])
        case updateBackUpDataSource([SongEntity])
        case updateLoadingState(Bool)
        case updateSelectedCount(Int)
        case updateSelectingStateByIndex([SongEntity])
        case showtoastMessage(String)
    }

    struct State {
        var isEditing: Bool
        var header: MyPlaylistHeaderModel
        var dataSource: [SongEntity]
        var backUpDataSource: [SongEntity]
        var isLoading: Bool
        var selectedCount: Int
        @Pulse var toastMessage: String?
    }

    var initialState: State
    private let fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase
    private let updatePlaylistUseCase: any UpdatePlaylistUseCase
    private let updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase
    private let removeSongsUseCase: any RemoveSongsUseCase
    private let uploadPlaylistImageUseCase: any UploadPlaylistImageUseCase

    private let logoutUseCase: any LogoutUseCase

    init(
        key: String,
        fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase,
        updatePlaylistUseCase: any UpdatePlaylistUseCase,
        updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase,
        removeSongsUseCase: any RemoveSongsUseCase,
        uploadPlaylistImageUseCase: any UploadPlaylistImageUseCase,
        logoutUseCase: any LogoutUseCase

    ) {
        self.key = key
        self.fetchPlaylistDetailUseCase = fetchPlaylistDetailUseCase
        self.updatePlaylistUseCase = updatePlaylistUseCase
        self.updateTitleAndPrivateUseCase = updateTitleAndPrivateUseCase
        self.removeSongsUseCase = removeSongsUseCase
        self.uploadPlaylistImageUseCase = uploadPlaylistImageUseCase
        self.logoutUseCase = logoutUseCase

        self.initialState = State(
            isEditing: false,
            header: MyPlaylistHeaderModel(
                key: key, title: "",
                image: "",
                userName: "",
                private: true,
                songCount: 0
            ),
            dataSource: [],
            backUpDataSource: [],
            isLoading: false,
            selectedCount: 0
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()
        case .editButtonDidTap:
            return beginEditing()

        case .privateButtonDidTap:
            return updatePrivate()

        case .forceSave, .completeButtonDidTap:
            return endEditing()

        case let .itemDidTap(index):
            return updateItemSelected(index)
        case .restore:
            return restoreDataSource()
        case let .itemDidMoved(from, to):
            return updateItemPosition(from: from, to: to)

        case let .changeTitle(text):
            return updateTitle(text: text)

        case .selectAll:
            return selectAll()

        case .deselectAll:
            return deselectAll()

        case .removeSongs:
            return removeSongs()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateEditingState(flag):
            newState.isEditing = flag

        case let .updateHeader(header):
            newState.header = header

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

        case let .showtoastMessage(message):
            newState.toastMessage = message
        }

        return newState
    }
}

private extension MyPlaylistDetailReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            fetchPlaylistDetailUseCase.execute(id: key, type: .my)
                .asObservable()
                .flatMap { data -> Observable<Mutation> in
                    return .concat([
                        Observable.just(Mutation.updateHeader(
                            MyPlaylistHeaderModel(
                                key: data.key,
                                title: data.title,
                                image: data.image,
                                userName: data.userName,
                                private: data.private,
                                songCount: data.songs.count
                            )
                        )),
                        Observable.just(Mutation.updateDataSource(data.songs))
                    ])
                }
                .catch { error in
                    let wmErorr = error.asWMError
                    return Observable.just(
                        Mutation.showtoastMessage(wmErorr.errorDescription ?? "알 수 없는 오류가 발생하였습니다.")
                    )
                },
            .just(.updateLoadingState(false))
        ])
    }

    func endEditing() -> Observable<Mutation> {
        #warning("저장 유즈 케이스")
        let state = currentState
        var currentDataSoruce = state.dataSource

        for i in 0 ..< currentDataSoruce.count {
            currentDataSoruce[i].isSelected = false
        }

        return .concat([
            .just(.updateEditingState(false)),
            .just(.updateDataSource(currentDataSoruce)),
            .just(.updateBackUpDataSource(currentDataSoruce)),
            .just(.updateSelectedCount(0)),
            updatePlaylistUseCase.execute(key: key, songs: currentDataSoruce.map { $0.id })
                .andThen(.empty())

        ])
    }

    func updatePrivate() -> Observable<Mutation> {
        let state = currentState

        var prev = state.header
        prev.updatePrivate()

        let message: String = prev.private ? "리스트를 비공개 처리했습니다." : "리스트를 공개 처리했습니다."

        return .concat([
            .just(.updateHeader(prev)),
            .just(.showtoastMessage(message)),
            updateTitleAndPrivateUseCase.execute(key: key, title: nil, isPrivate: prev.private)
                .andThen(.empty())
        ])
    }

    func updateTitle(text: String) -> Observable<Mutation> {
        let state = currentState

        var prev = state.header
        prev.updateTitle(text)

        return .concat([
            .just(.updateHeader(prev)),
            updateTitleAndPrivateUseCase.execute(key: key, title: text, isPrivate: nil)
                .andThen(.empty())
        ])
    }
}

/// usecase를 사용하지 않는
private extension MyPlaylistDetailReactor {
    func beginEditing() -> Observable<Mutation> {
        let state = currentState
        let currentDataSoruce = state.dataSource

        return .concat([
            .just(.updateEditingState(true)),
            .just(.updateBackUpDataSource(currentDataSoruce))
        ])
    }

    func updateItemSelected(_ index: Int) -> Observable<Mutation> {
        let state = currentState
        var count = state.selectedCount
        var prev = state.dataSource

        if prev[index].isSelected {
            count -= 1
        } else {
            count += 1
        }
        prev[index].isSelected = !prev[index].isSelected

        return .concat([
            .just(Mutation.updateSelectedCount(count)),
            .just(Mutation.updateSelectingStateByIndex(prev))
        ])
    }

    func updateItemPosition(from: Int, to: Int) -> Observable<Mutation> {
        let state = currentState
        var dataSource = state.dataSource

        let item = dataSource[from]

        dataSource.remove(at: from)

        dataSource.insert(item, at: to)

        return .just(Mutation.updateDataSource(dataSource))
    }

    func restoreDataSource() -> Observable<Mutation> {
        let state = currentState
        let backUpDataSource = state.backUpDataSource

        return .concat([
            .just(Mutation.updateEditingState(false)),
            .just(Mutation.updateDataSource(backUpDataSource)),
            .just(.updateSelectedCount(0))
        ])
    }

    func selectAll() -> Observable<Mutation> {
        let state = currentState
        var dataSource = state.dataSource

        for i in 0 ..< dataSource.count {
            dataSource[i].isSelected = true
        }

        return .concat([
            .just(.updateDataSource(dataSource)),
            .just(.updateSelectedCount(dataSource.count))
        ])
    }

    func deselectAll() -> Observable<Mutation> {
        let state = currentState
        var dataSource = state.dataSource

        for i in 0 ..< dataSource.count {
            dataSource[i].isSelected = false
        }

        return .concat([
            .just(.updateDataSource(dataSource)),
            .just(.updateSelectedCount(0))
        ])
    }

    func removeSongs() -> Observable<Mutation> {
        let state = currentState
        let dataSource = state.dataSource

        let remainSongs = dataSource.filter { !$0.isSelected }
        let removeSongs = dataSource.filter { $0.isSelected }.map { $0.id }
        var prevHeader = currentState.header
        prevHeader.updateSongCount(remainSongs.count)

        return .concat([
            .just(.updateDataSource(remainSongs)),
            .just(.updateBackUpDataSource(remainSongs)),
            .just(.updateEditingState(false)),
            .just(.updateSelectedCount(0)),
            .just(.updateHeader(prevHeader)),
            .just(.showtoastMessage("\(remainSongs.count)개의 곡을 삭제했습니다.")),
            removeSongsUseCase.execute(key: key, songs: removeSongs)
                .andThen(.never())

        ])
    }
}
