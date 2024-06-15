import LogManager
import ReactorKit
import SearchDomainInterface
import SongsDomainInterface

final class SongSearchResultReactor: Reactor {
    #warning("유즈케이스는 추후 연결")
    enum Action {
        case viewDidLoad
        case changeSortType(SortType)
        case changeFilterType(FilterType)
        #warning("무한 스크롤을 고려한 스크롤 액션")
    }

    enum Mutation {
        case updateSortType(SortType)
        case updateFilterType(FilterType)
        case updateDataSource([SongEntity])
        case updateSelectedCount(Int)
        case updateLoadingState(Bool)
    }

    struct State {
        var isLoading: Bool
        var sortType: SortType
        var filterType: FilterType
        var selectedCount: Int
        var scrollPage: Int
        var dataSource: [SongEntity]
    }

    var initialState: State

    private let fetchSearchSongsUseCase: any FetchSearchSongsUseCase
    private let text: String

    init(text: String, fetchSearchSongsUseCase: any FetchSearchSongsUseCase) {
        LogManager.printDebug("\(Self.self) init with Text :\(text)")

        self.initialState = State(
            isLoading: false,
            sortType: .latest,
            filterType: .all,
            selectedCount: 0,
            scrollPage: 1,
            dataSource: []
        )

        self.text = text
        self.fetchSearchSongsUseCase = fetchSearchSongsUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        
        let state = self.currentState
        
        switch action {
            
        case .viewDidLoad:
            return updateDataSource(order: state.sortType , filter: state.filterType, text: self.text, scrollPage: 1    )
        case let .changeSortType(type):
            return updateSortType(type)
        case let .changeFilterType(type):
            return updateFilterType(type)
        }
        
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSortType(type):
            newState.sortType = type
        case let .updateFilterType(type):
            newState.filterType = type
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource

        case let .updateSelectedCount(count):
            break
            
        case let .updateLoadingState(flag):
            newState.isLoading = flag
        }

        return newState
    }
}

extension SongSearchResultReactor {
    private func updateSortType(_ type: SortType) -> Observable<Mutation> {
        return .just(.updateSortType(type))
    }

    private func updateFilterType(_ type: FilterType) -> Observable<Mutation> {
        return .just(.updateFilterType(type))
    }
    
    
    private func updateDataSource(order: SortType, filter: FilterType, text: String, scrollPage: Int) -> Observable<Mutation> {
        
        return .concat([
            .just(Mutation.updateLoadingState(true)),
            fetchSearchSongsUseCase
                .execute(order: order, filter: filter, text: text, page: scrollPage, limit: 20)
                .asObservable()
                .map { dataSource -> Mutation in
                    return Mutation.updateDataSource(dataSource)
                },
            .just(Mutation.updateLoadingState(false))
        ])
        
    }
}
