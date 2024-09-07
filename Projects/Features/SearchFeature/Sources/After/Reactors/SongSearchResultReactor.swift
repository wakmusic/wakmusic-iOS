import Localization
import LogManager
import ReactorKit
import RxCocoa
import RxSwift
import SearchDomainInterface
import SongsDomainInterface

final class SongSearchResultReactor: Reactor {
    enum Action {
        case viewDidLoad
        case changeSortType(SortType)
        case changeFilterType(FilterType)
        case askLoadMore
        case deselectAll
        case itemDidTap(Int)
    }

    enum Mutation {
        case updateSortType(SortType)
        case updateFilterType(FilterType)
        case updateDataSource(dataSource: [SongEntity], canLoad: Bool)
        case updateLoadingState(Bool)
        case updateScrollPage(Int)
        case updateSelectedCount(Int)
        case updateSelectingStateByIndex([SongEntity])
        case showToast(String)
    }

    struct State {
        var isLoading: Bool
        var sortType: SortType
        var filterType: FilterType
        var selectedCount: Int
        var scrollPage: Int
        var dataSource: [SongEntity]
        var canLoad: Bool
        @Pulse var toastMessage: String?
    }

    var initialState: State

    private let fetchSearchSongsUseCase: any FetchSearchSongsUseCase
    private let text: String
    private let limit: Int = 20
    private var requestDisposeBag = DisposeBag()
    private let subject = PublishSubject<Mutation>()

    init(text: String, fetchSearchSongsUseCase: any FetchSearchSongsUseCase) {
        self.initialState = State(
            isLoading: true,
            sortType: .relevance,
            filterType: .all,
            selectedCount: 0,
            scrollPage: 1,
            dataSource: [],
            canLoad: true
        )

        self.text = text
        self.fetchSearchSongsUseCase = fetchSearchSongsUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        let state = self.currentState

        switch action {
        case .viewDidLoad, .askLoadMore:
            return updateDataSource(
                order: state.sortType,
                filter: state.filterType,
                text: self.text,
                scrollPage: state.scrollPage
            )

        case let .changeSortType(type):
            return updateSortType(type)
        case let .changeFilterType(type):
            return updateFilterType(type)

        case .deselectAll:
            return deselectAll()

        case let .itemDidTap(index):
            return updateItemSelected(index)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSortType(type):
            newState.sortType = type
        case let .updateFilterType(type):
            newState.filterType = type
        case let .updateDataSource(dataSource, canLoad):
            newState.dataSource = dataSource
            newState.canLoad = canLoad

        case let .updateLoadingState(isLoading):
            newState.isLoading = isLoading

        case let .updateScrollPage(page):
            newState.scrollPage = page

        case let .showToast(message):
            newState.toastMessage = message

        case let .updateSelectedCount(count):
            newState.selectedCount = count

        case let .updateSelectingStateByIndex(dataSource):
            newState.dataSource = dataSource
        }

        return newState
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let flatMapMutation = subject
            .withUnretained(self)
            .flatMap { owner, subjectMutation -> Observable<Mutation> in
                return .concat([
                    .just(subjectMutation),
                    .just(Mutation.updateScrollPage(owner.currentState.scrollPage + 1)),
                    .just(Mutation.updateLoadingState(false))
                ])
            }

        return Observable.merge(mutation, flatMapMutation)
    }
}

extension SongSearchResultReactor {
    private func updateSortType(_ type: SortType) -> Observable<Mutation> {
        let state = self.currentState

        return .concat([
            .just(.updateSelectedCount(0)),
            .just(.updateSortType(type)),
            updateDataSource(order: type, filter: state.filterType, text: self.text, scrollPage: 1)
        ])
    }

    private func updateFilterType(_ type: FilterType) -> Observable<Mutation> {
        let state = self.currentState

        return .concat([
            .just(.updateSelectedCount(0)),
            .just(.updateFilterType(type)),
            updateDataSource(order: state.sortType, filter: type, text: self.text, scrollPage: 1)
        ])
    }

    private func updateDataSource(
        order: SortType,
        filter: FilterType,
        text: String,
        scrollPage: Int
    ) -> Observable<Mutation> {
        requestDisposeBag = DisposeBag() // 기존 작업 캔슬

        fetchSearchSongsUseCase
            .execute(order: order, filter: filter, text: text, page: scrollPage, limit: limit)
            .asObservable()
            .map { [weak self] dataSource -> Mutation in

                guard let self else { return .updateDataSource(dataSource: [], canLoad: false) }

                let prev: [SongEntity] = scrollPage == 1 ? [] : self.currentState.dataSource
                if scrollPage == 1 {
                    LogManager.analytics(SearchAnalyticsLog.viewSearchResult(
                        keyword: self.text,
                        category: "song",
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
            }
            .bind(with: subject, onNext: { subject, mutation in
                subject.onNext(mutation)
            })
            .disposed(by: requestDisposeBag)

        return Observable.just(.updateLoadingState(true))
    }

    func updateItemSelected(_ index: Int) -> Observable<Mutation> {
        let state = currentState
        var count = state.selectedCount
        var prev = state.dataSource

        if prev[index].isSelected {
            count -= 1
        } else {
            count += 1
        }
        prev[index].isSelected = !prev[index].isSelected

        return .concat([
            .just(Mutation.updateSelectingStateByIndex(prev)),
            .just(Mutation.updateSelectedCount(count))
        ])
    }

    func deselectAll() -> Observable<Mutation> {
        let state = currentState
        var dataSource = state.dataSource

        for i in 0 ..< dataSource.count {
            dataSource[i].isSelected = false
        }

        return .concat([
            .just(.updateDataSource(dataSource: dataSource, canLoad: state.canLoad)),
            .just(.updateSelectedCount(0))
        ])
    }
}
