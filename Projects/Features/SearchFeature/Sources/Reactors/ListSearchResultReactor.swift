import ReactorKit
import SearchDomainInterface

final class ListSearchResultReactor: Reactor {
    enum Action {
        case viewDidLoad
        case changeSortType(SortType)
        case askLoadMore
    }

    enum Mutation {
        case updateSortType(SortType)
        case updateDataSource(dataSource: [SearchPlaylistEntity], canLoad: Bool)
        case updateLoadingState(Bool)
        case updateScrollPage
    }

    struct State {
        var isLoading: Bool
        var sortType: SortType
        var scrollPage: Int
        var dataSource: [SearchPlaylistEntity]
        var canLoad: Bool
    }

    var initialState: State
    private let text: String
    private let fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase
    private let limit: Int = 20

    init(text: String, fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase) {
        self.initialState = State(
            isLoading: false,
            sortType: .latest,
            scrollPage: 1,
            dataSource: [],
            canLoad: true
        )

        self.text = text
        self.fetchSearchPlaylistsUseCase = fetchSearchPlaylistsUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        let state = self.currentState

        switch action {
        case .viewDidLoad, .askLoadMore:
            return updateDataSource(order: state.sortType, text: self.text, scrollPage: state.scrollPage)
        case let .changeSortType(type):
            return updateSortType(type)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSortType(type):
            newState.sortType = type
        case let .updateDataSource(dataSource, canLoad):
            newState.dataSource += dataSource
            newState.canLoad = canLoad
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        case .updateScrollPage:
            newState.scrollPage += 1
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
                .execute(order: order, text: text, page: scrollPage, limit: limit)
                .asObservable()
                .map { [limit] dataSource -> Mutation in
                    return Mutation.updateDataSource(dataSource: dataSource, canLoad: dataSource.count == limit)
                },
            .just(Mutation.updateScrollPage),
            .just(Mutation.updateLoadingState(false))
        ])
    }
}
