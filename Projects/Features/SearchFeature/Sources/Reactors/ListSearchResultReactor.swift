import ReactorKit
import SearchDomainInterface

final class ListSearchResultReactor: Reactor {
    #warning("유즈케이스는 추후 연결")
    enum Action {
        case viewDidLoad
        case changeSortType(SortType)
        #warning("무한 스크롤을 고려한 스크롤 액션")
    }

    enum Mutation {
        case updateSortType(SortType)
    }

    struct State {
        var isLoading: Bool
        var sortType: SortType
        var scrollPage: Int
    }

    var initialState: State
    private let text: String

    init(_ text: String) {
        self.initialState = State(
            isLoading: false,
            sortType: .lastest,
            scrollPage: 0
        )

        self.text = text
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        case let .changeSortType(type):
            return updateSortType(type)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSortType(type):
            newState.sortType = type
        }

        return newState
    }
}

extension ListSearchResultReactor {
    private func updateSortType(_ type: SortType) -> Observable<Mutation> {
        #warning("데이터 소스 가져오기")
        return .just(.updateSortType(type))
    }
}
