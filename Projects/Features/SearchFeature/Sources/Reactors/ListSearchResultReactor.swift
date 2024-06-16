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
        case updateDataSource([SearchPlaylistEntity])
        case updateLoadingState(Bool)
    }

    struct State {
        var isLoading: Bool
        var sortType: SortType
        var scrollPage: Int
        var dataSource: [SearchPlaylistEntity]
    }

    var initialState: State
    private let text: String
    private let fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase

    init(text: String, fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase) {
        self.initialState = State(
            isLoading: false,
            sortType: .latest,
            scrollPage: 1,
            dataSource: []
        )

        self.text = text
        self.fetchSearchPlaylistsUseCase = fetchSearchPlaylistsUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource(order: .latest, text: self.text, scrollPage: 1)
        case let .changeSortType(type):
            return updateSortType(type)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSortType(type):
            newState.sortType = type
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}

extension ListSearchResultReactor {
    private func updateSortType(_ type: SortType) -> Observable<Mutation> {
        return .just(.updateSortType(type))
    }

    private func updateDataSource(
        order: SortType,
        text: String,
        scrollPage: Int
    ) -> Observable<Mutation> {
        return .concat([
            .just(Mutation.updateLoadingState(true)),
            fetchSearchPlaylistsUseCase
                .execute(order: order, text: text, page: scrollPage, limit: 20)
                .asObservable()
                .map { dataSource -> Mutation in
                    return Mutation.updateDataSource(dataSource)
                },
            .just(Mutation.updateLoadingState(false))
        ])
    }
}
