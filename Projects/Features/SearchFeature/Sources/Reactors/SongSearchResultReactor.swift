import ReactorKit
import LogManager

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
    private let text: String

    init(_ text: String) {
        LogManager.printDebug("\(Self.self) init with Text :\(text)")
        
        self.initialState = State(
            isLoading: false,
            sortType: .newest,
            filterType: .all,
            selectedCount: 0,
            scrollPage: 0
        )

        self.text = text
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        #warning("데이터 소스 가져오기")
        case .viewDidLoad:
            return .empty()
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
