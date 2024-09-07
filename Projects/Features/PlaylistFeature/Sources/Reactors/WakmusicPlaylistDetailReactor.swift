import AuthDomainInterface
import Foundation
import Localization
import PlaylistDomainInterface
import ReactorKit
import RxSwift
import SongsDomainInterface
import Utility

final class WakmusicPlaylistDetailReactor: Reactor {
    let key: String

    var disposeBag = DisposeBag()

    enum Action {
        case viewDidLoad
        case selectAll
        case deselectAll
        case itemDidTap(Int)
        case requestLoginRequiredAction
    }

    enum Mutation {
        case updateHeader(PlaylistDetailHeaderModel)
        case updateDataSource([SongEntity])
        case updateLoadingState(Bool)
        case updateSelectedCount(Int)
        case updateSelectingStateByIndex([SongEntity])
        case showToast(String)
        case updateLoginPopupState(Bool)
        case updatePlaylistURL(String)
    }

    struct State {
        var header: PlaylistDetailHeaderModel
        var dataSource: [SongEntity]
        var isLoading: Bool
        var selectedCount: Int
        var playlistURL: String?
        @Pulse var toastMessage: String?
        @Pulse var showLoginPopup: Bool
    }

    var initialState: State
    private let fetchWMPlaylistDetailUseCase: any FetchWMPlaylistDetailUseCase

    init(
        key: String,
        fetchWMPlaylistDetailUseCase: any FetchWMPlaylistDetailUseCase

    ) {
        self.key = key
        self.fetchWMPlaylistDetailUseCase = fetchWMPlaylistDetailUseCase

        self.initialState = State(
            header: PlaylistDetailHeaderModel(
                key: key, title: "",
                image: "",
                userName: "",
                private: false,
                songCount: 0
            ),
            dataSource: [],
            isLoading: true,
            selectedCount: 0,
            showLoginPopup: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()

        case .requestLoginRequiredAction:
            return .just(.updateLoginPopupState(true))

        case .selectAll:
            return selectAll()

        case .deselectAll:
            return deselectAll()

        case let .itemDidTap(index):
            return updateItemSelected(index)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateHeader(header):
            newState.header = header

        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource

        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        case let .updateSelectedCount(count):
            newState.selectedCount = count

        case let .showToast(message):
            newState.toastMessage = message

        case let .updateSelectingStateByIndex(dataSource):
            newState.dataSource = dataSource
        case let .updateLoginPopupState(flag):
            newState.showLoginPopup = flag

        case let .updatePlaylistURL(URL):
            newState.playlistURL = URL
        }

        return newState
    }
}

private extension WakmusicPlaylistDetailReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            fetchWMPlaylistDetailUseCase.execute(id: key)
                .asObservable()
                .flatMap { data -> Observable<Mutation> in
                    return .concat([
                        Observable.just(Mutation.updateHeader(
                            PlaylistDetailHeaderModel(
                                key: data.key,
                                title: data.title,
                                image: data.image,
                                userName: "Wakmu",
                                private: false,
                                songCount: data.songs.count
                            )
                        )),
                        Observable.just(.updatePlaylistURL(data.playlistURL)),
                        Observable.just(Mutation.updateDataSource(data.songs))
                    ])
                }
                .catch { error in
                    let wmErorr = error.asWMError
                    return Observable.just(
                        Mutation.showToast(wmErorr.errorDescription ?? LocalizationStrings.unknownErrorWarning)
                    )
                },
            .just(.updateLoadingState(false))
        ])
    }
}

/// usecase를 사용하지 않는
private extension WakmusicPlaylistDetailReactor {
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
}
