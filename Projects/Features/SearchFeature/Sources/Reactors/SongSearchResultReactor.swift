import LogManager
import ReactorKit
import SearchDomainInterface

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
    }

    struct State {
        var isLoading: Bool
        var sortType: SortType
        var filterType: FilterType
        var selectedCount: Int
        var scrollPage: Int
    }

    var initialState: State
    
    private let fetchSearchSongsUseCase: any FetchSearchSongsUseCase
    private let text: String

    init(text: String, fetchSearchSongsUseCase: any FetchSearchSongsUseCase) {
        LogManager.printDebug("\(Self.self) init with Text :\(text)")

        self.initialState = State(
            isLoading: false,
            sortType: .lastest,
            filterType: .all,
            selectedCount: 0,
            scrollPage: 0
        )
        
        self.text = text
        self.fetchSearchSongsUseCase = fetchSearchSongsUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        #warning("추후 구현하기")
        return .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSortType(type):
            newState.sortType = type
        case let .updateFilterType(type):
            newState.filterType = type
        }

        return newState
    }
}

extension SongSearchResultReactor {
    private func updateSortType(_ type: SortType) -> Observable<Mutation> {
        #warning("데이터 소스 가져오기")
        return .just(.updateSortType(type))
    }

    private func updateFilterType(_ type: FilterType) -> Observable<Mutation> {
        #warning("데이터 소스 가져오기")
        return .just(.updateFilterType(type))
    }
}
