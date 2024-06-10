import Foundation
import PlayListDomainInterface
import ReactorKit
import RxSwift
import Utility

public final class BeforeSearchReactor: Reactor {
    private let disposeBag: DisposeBag = DisposeBag()

    private let fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase

    public var initialState: State

    private let service: any SearchCommonService

    public enum Action {
        case viewDidLoad
        case updateShowRecommend(Bool)
        case rencentTextDidTap(String)
    }

    public enum Mutation {
        case updateRecommend([RecommendPlayListEntity])
        case updateShowRecommend(Bool)
        case updateRecentText(String)
        case updateLoadingState(Bool)
    }

    public struct State {
        var showRecommend: Bool
        var dataSource: [RecommendPlayListEntity]
        var isLoading: Bool
    }

    init(
        fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase,
        service: some SearchCommonService = DefaultSearchCommonService.shared
    ) {
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
        self.service = service
        self.initialState = State(
            showRecommend: true,
            dataSource: [],
            isLoading: true
        )
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchRecommend()
        case let .updateShowRecommend(flag):
            return Observable.just(.updateShowRecommend(flag))
        case let .rencentTextDidTap(text):
            return updateRecentText(text)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateRecommend(dataSource):
            newState.dataSource = dataSource
        case let .updateShowRecommend(flag):
            newState.showRecommend = flag
        case .updateRecentText:
            #warning("유즈 케이스 연결 후 구현")
            break
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }

    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let typingState = service.typingStatus.map { Mutation.updateShowRecommend($0 == .before) }

        return Observable.merge(mutation, typingState)
    }
}

extension BeforeSearchReactor {
    func fetchRecommend() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            fetchRecommendPlayListUseCase
                .execute()
                .asObservable()
                .map { Mutation.updateRecommend($0) },
            .just(.updateLoadingState(false))
        ])
    }

    func updateRecentText(_ text: String) -> Observable<Mutation> {
        service.recentText.onNext(text)
        service.typingStatus.onNext(.search)

        return .empty()
    }
}
