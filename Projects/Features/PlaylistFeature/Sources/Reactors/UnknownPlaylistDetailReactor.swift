import AuthDomainInterface
import Foundation
import Localization
import LogManager
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
        case requestLoginRequiredAction(source: LoginRequiredActionSource)

        enum LoginRequiredActionSource {
            case addMusics
        }
    }

    enum Mutation {
        case updateHeader(PlaylistDetailHeaderModel)
        case updateDataSource([SongEntity])
        case updateLoadingState(Bool)
        case updateSelectedCount(Int)
        case updateSelectingStateByIndex([SongEntity])
        case updateSubscribeState(Bool)
        case showToast(String)
        case updateLoginPopupState((Bool, CommonAnalyticsLog.LoginButtonEntry?))
        case updateRefresh
    }

    struct State {
        var header: PlaylistDetailHeaderModel
        var dataSource: [SongEntity]
        var isLoading: Bool
        var selectedCount: Int
        var isSubscribing: Bool
        @Pulse var toastMessage: String?
        @Pulse var showLoginPopup: (Bool, CommonAnalyticsLog.LoginButtonEntry?)
        @Pulse var refresh: Void?
        @Pulse var detectedNotFound: Void?
    }

    var initialState: State
    private let fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase
    private let subscribePlaylistUseCase: any SubscribePlaylistUseCase
    private let checkSubscriptionUseCase: any CheckSubscriptionUseCase
    private let playlistCommonService: any PlaylistCommonService

    private let logoutUseCase: any LogoutUseCase

    init(
        key: String,
        fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase,
        subscribePlaylistUseCase: any SubscribePlaylistUseCase,
        checkSubscriptionUseCase: any CheckSubscriptionUseCase,
        logoutUseCase: any LogoutUseCase,
        playlistCommonService: any PlaylistCommonService = DefaultPlaylistCommonService.shared
    ) {
        self.key = key
        self.fetchPlaylistDetailUseCase = fetchPlaylistDetailUseCase
        self.subscribePlaylistUseCase = subscribePlaylistUseCase
        self.checkSubscriptionUseCase = checkSubscriptionUseCase
        self.logoutUseCase = logoutUseCase
        self.playlistCommonService = playlistCommonService

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
            isSubscribing: false,
            showLoginPopup: (false, nil)
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()

        case .subscriptionButtonDidTap:
            return askUpdateSubscribing()

        case .selectAll:
            return selectAll()

        case .deselectAll:
            return deselectAll()

        case let .itemDidTap(index):
            return updateItemSelected(index)

        case let .requestLoginRequiredAction(source):
            switch source {
            case .addMusics:
                return .just(.updateLoginPopupState((true, .addMusics)))
            }
            return .just(.updateLoginPopupState((true, nil)))
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

        case let .updateLoginPopupState(flag):
            newState.showLoginPopup = flag

        case let .updateSelectingStateByIndex(dataSource):
            newState.dataSource = dataSource

        case let .updateSubscribeState(flag):
            newState.isSubscribing = flag

        case .updateRefresh:
            newState.refresh = ()
        }

        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let removeSubscriptionPlaylistEvent = playlistCommonService.removeSubscriptionPlaylistEvent
            .withUnretained(self)
            .flatMap { owner, notification -> Observable<Mutation> in
                guard let removedPlaylistKeys = notification.object as? [String] else {
                    return .empty()
                }

                return removedPlaylistKeys.contains(owner.key) ? owner.checkSubscription() : .empty()
            }

        return Observable.merge(removeSubscriptionPlaylistEvent, mutation)
    }
}

private extension UnknownPlaylistDetailReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            fetchPlaylistDetailUseCase.execute(id: key, type: .unknown)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, data -> Observable<Mutation> in
                    let songs = data.songs.uniqued()
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
                        Observable.just(
                            Mutation.updateDataSource(Array(songs))
                        ),
                        PreferenceManager.shared.userInfo == nil ? .just(.updateSubscribeState(false)) : owner
                            .checkSubscription()
                    ])
                }
                .catch { [weak self] error in

                    guard let self else { return .empty() }

                    let wmError = error.asWMError

                    return Observable.just(
                        Mutation.showToast(wmError.errorDescription ?? LocalizationStrings.unknownErrorWarning)
                    )
                },
            .just(.updateLoadingState(false))
        ])
    }

    func checkSubscription() -> Observable<Mutation> {
        return checkSubscriptionUseCase.execute(key: key)
            .asObservable()
            .flatMap { flag -> Observable<Mutation> in
                return .just(.updateSubscribeState(flag))
            }
            .catch { error in
                let wmErorr = error.asWMError
                return Observable.just(
                    Mutation.showToast(wmErorr.errorDescription ?? LocalizationStrings.unknownErrorWarning)
                )
            }
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

    func askUpdateSubscribing() -> Observable<Mutation> {
        let currentState = currentState

        let prev = currentState.isSubscribing

        if PreferenceManager.shared.userInfo == nil {
            return .just(.updateLoginPopupState((true, .playlistSubscribe)))
        } else {
            return subscribePlaylistUseCase.execute(key: key, isSubscribing: prev)
                .andThen(
                    .concat([
                        .just(Mutation.updateSubscribeState(!prev)),
                        .just(Mutation.showToast(prev ? "리스트 구독을 취소 했습니다." : "리스트 구독을 했습니다.")),
                        updateSendRefreshNoti()
                    ])
                )
                .catch { error in
                    let wmError = error.asWMError
                    return .just(.showToast(wmError.errorDescription!))
                }
        }
    }

    func updateSubscribeState(_ flag: Bool) -> Observable<Mutation> {
        return .just(.updateSubscribeState(flag))
    }

    func updateSendRefreshNoti() -> Observable<Mutation> {
        .just(.updateRefresh)
    }
}
