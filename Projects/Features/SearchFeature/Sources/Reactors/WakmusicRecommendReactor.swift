import Foundation
import LogManager
import PlayListDomainInterface
import ReactorKit
import RxSwift

final class WakmusicRecommendReactor: Reactor {
    private var disposeBag: DisposeBag = DisposeBag()
    private var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase

    var initialState: State

    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateDataSource([RecommendPlayListEntity])
    }

    struct State {
        var dataSource: [RecommendPlayListEntity]
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
        }

        return newState
    }

    init(fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase) {
        LogManager.printDebug("✅ \(Self.self)")
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
        self.initialState = State(
            dataSource: []
        )
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self)")
    }
}

extension WakmusicRecommendReactor {
    func updateDataSource() -> Observable<Mutation> {
        return fetchRecommendPlayListUseCase
            .execute()
            .asObservable()
            .map { Mutation.updateDataSource($0) }
    }
}
