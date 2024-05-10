import Foundation
import PlayListDomainInterface
import ReactorKit
import RxSwift

public final class BeforeSearchReactor: Reactor {
    private let disposeBag: DisposeBag = DisposeBag()

    private let fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase

    public enum Action {
        case viewDidLoad
        case updateShowRecommend(Bool)
    }

    public enum Mutation {
        case updateRecommend([RecommendPlayListEntity])
        case updateShowRecommend(Bool)
    }

    public struct State {
        var showRecommend: Bool
        var dataSource: [RecommendPlayListEntity]
    }

    public var initialState: State

    init(fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase) {
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
        self.initialState = State(
            showRecommend: true,
            dataSource: []
        )
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateRecommend(dataSource):
            newState.dataSource = dataSource
        case let .updateShowRecommend(flag):
            newState.showRecommend = flag
        }

        return newState
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchRecommend()
        case let .updateShowRecommend(flag):
            return Observable.just(.updateShowRecommend(flag))
        }
    }
}

extension BeforeSearchReactor {
    func fetchRecommend() -> Observable<Mutation> {
        return fetchRecommendPlayListUseCase
            .execute()
            .asObservable()
            .map { Mutation.updateRecommend($0) }
    }
}
