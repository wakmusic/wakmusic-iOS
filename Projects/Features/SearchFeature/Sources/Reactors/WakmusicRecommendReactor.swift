import Foundation
import LogManager
import PlaylistDomainInterface
import ReactorKit
import RxSwift

final class WakmusicRecommendReactor: Reactor {
    private var disposeBag: DisposeBag = DisposeBag()
    private var fetchRecommendPlaylistUseCase: any FetchRecommendPlayListUseCase

    var initialState: State

    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateDataSource([RecommendPlaylistEntity])
        case updateLodingState(Bool)
    }

    struct State {
        var dataSource: [RecommendPlaylistEntity]
        var isLoading: Bool
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        case let .updateLodingState(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }

    init(fetchRecommendPlaylistUseCase: any FetchRecommendPlayListUseCase) {
        LogManager.printDebug("✅ \(Self.self)")
        self.fetchRecommendPlaylistUseCase = fetchRecommendPlaylistUseCase
        self.initialState = State(
            dataSource: [],
            isLoading: true
        )
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self)")
    }
}

extension WakmusicRecommendReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLodingState(true)),
            fetchRecommendPlaylistUseCase
                .execute()
                .asObservable()
                .map { Mutation.updateDataSource($0) },
            .just(.updateLodingState(false))
        ])
    }

    func updateLoadnigState(isLoading: Bool) -> Observable<Mutation> {
        return .just(.updateLodingState(isLoading))
    }
}
