import AuthDomainInterface
import Foundation
import PlaylistDomainInterface
import ReactorKit
import RxSwift
import SongsDomainInterface
import Utility

final class UnknownPlaylistDetailReactor: Reactor {
    let key: String

    enum Action {
        case viewDidLoad
        case selectAll
        case deselectAll
        case itemDidTap(Int)
        case subscriptionButtonDidTap
    }

    enum Mutation {
        case updateHeader(PlaylistDetailHeaderModel)
        case updateDataSource([SongEntity])
        case updateLoadingState(Bool)
        case updateSelectedCount(Int)
        case updateSelectingStateByIndex([SongEntity])
        case updateSubscribeState(Bool)
        case showToast(String)
    }

    struct State {
        var header: PlaylistDetailHeaderModel
        var dataSource: [SongEntity]
        var isLoading: Bool
        var selectedCount: Int
        var isSubscribing: Bool
        @Pulse var toastMessage: String?
    }

    var initialState: State
    private let fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase
    private let subscribePlaylistUseCase: any SubscribePlaylistUseCase
    private let checkSubscriptionUseCase: any CheckSubscriptionUseCase

    private let logoutUseCase: any LogoutUseCase

    init(
        key: String,
        fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase,
        subscribePlaylistUseCase: any SubscribePlaylistUseCase,
        checkSubscriptionUseCase: any CheckSubscriptionUseCase,
        logoutUseCase: any LogoutUseCase

    ) {
        self.key = key
        self.fetchPlaylistDetailUseCase = fetchPlaylistDetailUseCase
        self.subscribePlaylistUseCase = subscribePlaylistUseCase
        self.checkSubscriptionUseCase = checkSubscriptionUseCase
        self.logoutUseCase = logoutUseCase

        self.initialState = State(
            header: PlaylistDetailHeaderModel(
                key: key, title: "",
                image: "",
                userName: "",
                private: false,
                songCount: 0
            ),
            dataSource: [],
            isLoading: false,
            selectedCount: 0,
            isSubscribing: false
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()

        case .subscriptionButtonDidTap:
            return askUpdateSubscribeUsecase()

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

        case let .updateSubscribeState(flag):
            newState.isSubscribing = flag
        }

        return newState
    }
}

private extension UnknownPlaylistDetailReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            fetchPlaylistDetailUseCase.execute(id: key, type: .unknown)
                .asObservable()
                .flatMap { data -> Observable<Mutation> in
                    return .concat([
                        Observable.just(Mutation.updateHeader(
                            PlaylistDetailHeaderModel(
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
                        Mutation.showToast(wmErorr.errorDescription ?? "알 수 없는 오류가 발생하였습니다.")
                    )
                },

            // 로그인 전이면 USECASE 안보냄
            checkSubscriptionUseCase.execute(key: key)
                .asObservable()
                .flatMap { flag -> Observable<Mutation> in
                    return .just(.updateSubscribeState(flag))
                }
                .catch { error in
                    let wmErorr = error.asWMError
                    return Observable.just(
                        Mutation.showToast(wmErorr.errorDescription ?? "알 수 없는 오류가 발생하였습니다.")
                    )
                },
            .just(.updateLoadingState(false))
        ])
    }
}

/// usecase를 사용하지 않는
private extension UnknownPlaylistDetailReactor {
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

    func askUpdateSubscribeUsecase() -> Observable<Mutation> {
        let currentState = currentState

        let prev = currentState.isSubscribing

        return subscribePlaylistUseCase.execute(key: key, isSubscribing: prev)
            .andThen(
                .concat([
                    .just(Mutation.updateSubscribeState(!prev)),
                    .just(Mutation.showToast(prev ? "리스트 구독을 취소 했습니다." : "리스트 구독을 했습니다."))
                ])
            )
            .catch { error in
                let wmError = error.asWMError
                return .just(.showToast(wmError.errorDescription!))
            }
    }

    func updateSubscribeState(_ flag: Bool) -> Observable<Mutation> {
        return .just(.updateSubscribeState(flag))
    }
}
