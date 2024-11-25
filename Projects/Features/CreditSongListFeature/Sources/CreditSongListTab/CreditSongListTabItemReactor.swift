import BaseFeature
import CreditDomainInterface
import CreditSongListFeatureInterface
import Localization
import LogManager
import ReactorKit
import RxSwift
import Utility

final class CreditSongListTabItemReactor: Reactor {
    private enum Metric {
        static let pageLimit = 50
        static let availableLimit = 50
    }

    enum Action {
        case viewDidLoad
        case songDidTap(id: String)
        case songThumbnailDidTap(model: CreditSongModel)
        case randomPlayButtonDidTap
        case allSelectButtonDidTap
        case allDeselectButtonDidTap
        case addSongButtonDidTap
        case addPlaylistButtonDidTap
        case playButtonDidTap
        case reachedBottom
    }

    enum Mutation {
        case updateSelectedSongs(Set<String>)
        case updateSongs([CreditSongModel])
        case updateNavigateType(NavigateType?)
        case updateIsLoading(Bool)
        case updateToastMessage(String)
    }

    enum NavigateType {
        case playYoutube(ids: [String], playPlatform: WakmusicYoutubePlayer.PlayPlatform)
        case containSongs(ids: [String])
        case textPopup(text: String, completion: () -> Void)
        case signIn
        case dismiss(completion: () -> Void)
    }

    struct State {
        var songs: [CreditSongModel] = []
        var selectedSongs: Set<String> = []
        @Pulse var navigateType: NavigateType?
        @Pulse var isLoading = false
        @Pulse var toastMessage: String?
    }

    private let signInIsRequiredSubject = PublishSubject<Void>()

    private var page: Int = 1
    private var isLastPage: Bool = false
    let initialState: State
    let workerName: String
    private let creditSortType: CreditSongSortType
    private let songDetailPresenter: any SongDetailPresentable
    private let fetchCreditSongListUseCase: any FetchCreditSongListUseCase

    init(
        workerName: String,
        creditSortType: CreditSongSortType,
        songDetailPresenter: any SongDetailPresentable,
        fetchCreditSongListUseCase: any FetchCreditSongListUseCase
    ) {
        self.initialState = .init()
        self.workerName = workerName
        self.creditSortType = creditSortType
        self.songDetailPresenter = songDetailPresenter
        self.fetchCreditSongListUseCase = fetchCreditSongListUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        case let .songDidTap(id):
            return songDidTap(id: id)
        case let .songThumbnailDidTap(model):
            PlayState.shared.append(item: .init(id: model.id, title: model.title, artist: model.artist))
            return navigateMutation(navigateType: .dismiss(completion: { [songDetailPresenter] in
                let playlistIDs = PlayState.shared.currentPlaylist
                    .map(\.id)
                songDetailPresenter.present(ids: playlistIDs, selectedID: model.id)
            }))
        case .randomPlayButtonDidTap:
            return randomPlayButtonDidTap()
        case .allSelectButtonDidTap:
            return allSelectButtonDidTap()
        case .allDeselectButtonDidTap:
            return allDeselectButtonDidTap()
        case .addSongButtonDidTap:
            return addSongButtonDidTap()
        case .addPlaylistButtonDidTap:
            return addPlaylistButtonDidTap()
        case .playButtonDidTap:
            return playButtonDidTap()
        case .reachedBottom:
            return reachedBottom()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSongs(songs):
            newState.songs = songs
        case let .updateSelectedSongs(selectedSongs):
            newState.selectedSongs = selectedSongs
        case let .updateNavigateType(navigateType):
            newState.navigateType = navigateType
        case let .updateIsLoading(isLoading):
            newState.isLoading = isLoading
        case let .updateToastMessage(toastMessage):
            newState.toastMessage = toastMessage
        }

        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let signinIsRequired = signInIsRequiredSubject
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.navigateMutation(navigateType: .signIn)
            }

        return Observable.merge(mutation, signinIsRequired)
    }
}

// MARK: - Mutate

private extension CreditSongListTabItemReactor {
    func viewDidLoad() -> Observable<Mutation> {
        let initialCreditSongListObservable = fetchPaginatedCreditSongList()
            .do(onNext: { [weak self] creditModels in
                if creditModels.isEmpty || creditModels.count < Metric.pageLimit {
                    self?.isLastPage = true
                }
            })
            .map(Mutation.updateSongs)
        return withLoadingMutation(observable: initialCreditSongListObservable)
    }

    func songDidTap(id: String) -> Observable<Mutation> {
        var currentSelectedSongIDs = currentState.selectedSongs
        if currentSelectedSongIDs.contains(id) {
            currentSelectedSongIDs.remove(id)
        } else {
            currentSelectedSongIDs.insert(id)
        }
        return .just(.updateSelectedSongs(currentSelectedSongIDs))
    }

    func randomPlayButtonDidTap() -> Observable<Mutation> {
        let randomSongs = currentState.songs.map(\.id)
            .shuffled()
            .prefix(50)
        let songs = Array(randomSongs)
        let playPlatform = if currentState.songs.allSatisfy({ $0.title.isContainShortsTagTitle }) {
            WakmusicYoutubePlayer.PlayPlatform.youtube
        } else {
            WakmusicYoutubePlayer.PlayPlatform.automatic
        }
        return navigateMutation(navigateType: .playYoutube(ids: songs, playPlatform: playPlatform))
    }

    func allSelectButtonDidTap() -> Observable<Mutation> {
        let allSongIDs = Set(currentState.songs.map(\.id))
        return .just(.updateSelectedSongs(allSongIDs))
    }

    func allDeselectButtonDidTap() -> Observable<Mutation> {
        return .just(.updateSelectedSongs([]))
    }

    func addSongButtonDidTap() -> Observable<Mutation> {
        guard PreferenceManager.shared.userInfo != nil else {
            return navigateMutation(
                navigateType: .textPopup(
                    text: LocalizationStrings.needLoginWarning,
                    completion: { [signInIsRequiredSubject] in
                        let log = CommonAnalyticsLog.clickLoginButton(entry: .addMusics)
                        LogManager.analytics(log)

                        signInIsRequiredSubject.onNext(())
                    }
                )
            )
        }

        let containingSongIDs = currentState.songs
            .filter { currentState.selectedSongs.contains($0.id) }
            .map(\.id)

        if containingSongIDs.count > Metric.availableLimit {
            return .just(.updateToastMessage(
                Localization.LocalizationStrings
                    .overFlowAddPlaylistWarning(containingSongIDs.count - Metric.availableLimit)
            ))
        }

        return navigateMutation(navigateType: .containSongs(ids: containingSongIDs))
    }

    func addPlaylistButtonDidTap() -> Observable<Mutation> {
        let appendingSongs = currentState.songs
            .filter { currentState.selectedSongs.contains($0.id) }
            .map { PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist) }

        PlayState.shared.append(contentsOf: appendingSongs)
        return .just(.updateToastMessage(Localization.LocalizationStrings.addList))
    }

    func playButtonDidTap() -> Observable<Mutation> {
        let containTargetSongIDs = Array(currentState.selectedSongs)

        if containTargetSongIDs.count > Metric.availableLimit {
            return .just(.updateToastMessage(
                Localization.LocalizationStrings
                    .overFlowPlayWarning(containTargetSongIDs.count - Metric.availableLimit)
            ))
        }

        let isOnlyShorts = currentState.songs
            .filter { currentState.selectedSongs.contains($0.id) }
            .allSatisfy { $0.title.isContainShortsTagTitle }
        let playPlatform = if isOnlyShorts {
            WakmusicYoutubePlayer.PlayPlatform.youtube
        } else {
            WakmusicYoutubePlayer.PlayPlatform.automatic
        }

        return navigateMutation(navigateType: .playYoutube(ids: containTargetSongIDs, playPlatform: playPlatform))
    }

    func reachedBottom() -> Observable<Mutation> {
        guard !isLastPage else { return .empty() }
        let initialCreditSongListObservable = fetchPaginatedCreditSongList()
            .do(onNext: { [weak self] creditModels in
                if creditModels.isEmpty || creditModels.count < Metric.pageLimit {
                    self?.isLastPage = true
                }
            })
            .map { [weak self] in return $0 + (self?.currentState.songs ?? []) }
            .map(Mutation.updateSongs)
        return withLoadingMutation(observable: initialCreditSongListObservable)
    }
}

// MARK: - Private Methods

private extension CreditSongListTabItemReactor {
    func fetchPaginatedCreditSongList() -> Observable<[CreditSongModel]> {
        return fetchCreditSongListUseCase.execute(
            name: workerName,
            order: creditSortType.toDomain(),
            page: page,
            limit: Metric.pageLimit
        )
        .do(onSuccess: { [weak self] _ in
            self?.page += 1
        })
        .map { $0.map { CreditSongModel(songEntity: $0) } }
        .asObservable()
    }

    func withLoadingMutation(observable: Observable<Mutation>) -> Observable<Mutation> {
        return .concat(
            .just(.updateIsLoading(true)),
            observable,
            .just(.updateIsLoading(false))
        )
    }

    func navigateMutation(navigateType: NavigateType) -> Observable<Mutation> {
        return .concat(
            .just(.updateNavigateType(navigateType)),
            .just(.updateNavigateType(nil))
        )
    }
}

private extension CreditSongSortType {
    func toDomain() -> CreditSongOrderType {
        switch self {
        case .latest:
            return .latest
        case .popular:
            return .popular
        case .oldest:
            return .oldest
        }
    }
}
