import BaseFeature
import CreditDomainInterface
import CreditSongListFeatureInterface
import Localization
import ReactorKit

final class CreditSongListTabItemReactor: Reactor {
    private enum Metric {
        static let pageLimit = 50
    }

    enum Action {
        case viewDidLoad
        case songDidTap(id: String)
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
        case playYoutube(ids: [String])
        case containSongs(ids: [String])
    }

    struct State {
        var songs: [CreditSongModel] = []
        var selectedSongs: Set<String> = []
        @Pulse var navigateType: NavigateType?
        @Pulse var isLoading = false
        @Pulse var toastMessage: String?
    }

    private var page: Int = 1
    let initialState: State
    private let workerName: String
    private let creditSortType: CreditSongSortType
    private let fetchCreditSongListUseCase: any FetchCreditSongListUseCase

    init(
        workerName: String,
        creditSortType: CreditSongSortType,
        fetchCreditSongListUseCase: any FetchCreditSongListUseCase
    ) {
        self.initialState = .init()
        self.workerName = workerName
        self.creditSortType = creditSortType
        self.fetchCreditSongListUseCase = fetchCreditSongListUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        case let .songDidTap(id):
            return songDidTap(id: id)
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
        return .empty()
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
}

// MARK: - Mutate

private extension CreditSongListTabItemReactor {
    func viewDidLoad() -> Observable<Mutation> {
        let initialCreditSongListObservable = fetchPaginatedCreditSongList()
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
        return navigateMutation(navigateType: .playYoutube(ids: songs))
    }

    func allSelectButtonDidTap() -> Observable<Mutation> {
        let allSongIDs = Set(currentState.songs.map(\.id))
        return .just(.updateSelectedSongs(allSongIDs))
    }

    func allDeselectButtonDidTap() -> Observable<Mutation> {
        return .just(.updateSelectedSongs([]))
    }

    func addSongButtonDidTap() -> Observable<Mutation> {
        let containingSongIDs = currentState.songs
            .filter { currentState.selectedSongs.contains($0.id) }
            .map(\.id)
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
        return navigateMutation(navigateType: .playYoutube(ids: containTargetSongIDs))
    }

    func reachedBottom() -> Observable<Mutation> {
        let initialCreditSongListObservable = fetchPaginatedCreditSongList()
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
