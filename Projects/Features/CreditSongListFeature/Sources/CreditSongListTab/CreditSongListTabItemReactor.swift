import CreditDomainInterface
import CreditSongListFeatureInterface
import ReactorKit

final class CreditSongListTabItemReactor: Reactor {
    private enum Metric {
        static let pageLimit = 50
    }

    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateSongs([CreditSongModel])
    }

    struct State {
        var songs: [CreditSongModel] = []
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
        }
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSongs(songs):
            newState.songs = songs
        }

        return newState
    }
}

private extension CreditSongListTabItemReactor {
    func viewDidLoad() -> Observable<Mutation> {
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
        .map(Mutation.updateSongs)
        .asObservable()
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
