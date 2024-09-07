import Localization
import LogManager
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
        case updateScrollPage(Int)
        case showToast(String)
    }

    struct State {
        var isLoading: Bool
        var sortType: SortType
        var scrollPage: Int
        var dataSource: [SearchPlaylistEntity]
        var canLoad: Bool
        @Pulse var toastMessage: String?
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
            newState.dataSource = dataSource
            newState.canLoad = canLoad
        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading
        case let .updateScrollPage(page):
            newState.scrollPage = page
        case let .showToast(message):
            newState.toastMessage = message
        }

        return newState
    }
}

extension ListSearchResultReactor {
    private func updateSortType(_ type: SortType) -> Observable<Mutation> {
        return .concat([
            .just(.updateSortType(type)),
            updateDataSource(order: type, text: self.text, scrollPage: 1)
        ])
    }

    private func updateDataSource(
        order: SortType,
        text: String,
        scrollPage: Int
    ) -> Observable<Mutation> {
        let prev: [SearchPlaylistEntity] = scrollPage == 1 ? [] : self.currentState.dataSource

        return .concat([
            .just(Mutation.updateLoadingState(true)),
            fetchSearchPlaylistsUseCase
                .execute(order: order, text: text, page: scrollPage, limit: limit)
                .asObservable()
                .map { [weak self] dataSource -> Mutation in

                    guard let self else { return .updateDataSource(dataSource: [], canLoad: false) }

                    if scrollPage == 1 {
                        LogManager.analytics(SearchAnalyticsLog.viewSearchResult(
                            keyword: self.text,
                            category: "list",
                            count: dataSource.count
                        ))
                    }

                    return Mutation.updateDataSource(dataSource: prev + dataSource, canLoad: dataSource.count == limit)
                }
                .catch { error in
                    let wmErorr = error.asWMError
                    return Observable.just(
                        Mutation.showToast(wmErorr.errorDescription ?? LocalizationStrings.unknownErrorWarning)
                    )
                },
            .just(Mutation.updateScrollPage(scrollPage + 1)),
            .just(Mutation.updateLoadingState(false))
        ])
    }
}
