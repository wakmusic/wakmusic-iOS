import Foundation
import PlayListDomainInterface
import ReactorKit
import RxSwift
import Utility
import ChartDomainInterface

public struct WrapperDataSourceModel  {
    let currentVideo: CurrentVideoEntity
    let recommendPlayList: [RecommendPlayListEntity]
}

public final class BeforeSearchReactor: Reactor {
    private let disposeBag: DisposeBag = DisposeBag()

    private let fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase
    private let fetchCurrentVideoUseCase: FetchCurrentVideoUseCase

    public var initialState: State

    private let service: any SearchCommonService

    public enum Action {
        case viewDidLoad
        case updateShowRecommend(Bool)
        case rencentTextDidTap(String)
    }

    public enum Mutation {
        case updateDataSource(WrapperDataSourceModel)
        case updateShowRecommend(Bool)
        case updateLoadingState(Bool)
    }

    public struct State {
        var showRecommend: Bool
        var isLoading: Bool
        var dataSource: WrapperDataSourceModel
    }

    init(
        fetchCurrentVideoUseCase: FetchCurrentVideoUseCase,
        fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase,
        service: some SearchCommonService = DefaultSearchCommonService.shared
    ) {
        self.fetchCurrentVideoUseCase = fetchCurrentVideoUseCase
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
        self.service = service
        self.initialState = State(
            showRecommend: true,
            isLoading: false,
            dataSource: WrapperDataSourceModel(currentVideo: .init(id: ""), recommendPlayList: [])
        )
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()
        case let .updateShowRecommend(flag):
            return Observable.just(.updateShowRecommend(flag))
        case let .rencentTextDidTap(text):
            return updateRecentText(text)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        
        case let .updateDataSource(data):
            newState.dataSource = data
        
        case let .updateShowRecommend(flag):
            newState.showRecommend = flag
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
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            
            Observable.zip( 
                fetchCurrentVideoUseCase
                .execute()
                .asObservable(),
                fetchRecommendPlayListUseCase
                .execute()
                .asObservable()
            ).map{ Mutation.updateDataSource(WrapperDataSourceModel(currentVideo: $0.0, recommendPlayList: $0.1)) }
            
,
            .just(.updateLoadingState(false))
        ])
    }

    func updateRecentText(_ text: String) -> Observable<Mutation> {
        service.recentText.onNext(text)
        service.typingStatus.onNext(.search)

        return .empty()
    }
}
