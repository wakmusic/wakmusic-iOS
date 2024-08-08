import Foundation
import Localization
import LogManager
import PlaylistDomainInterface
import ReactorKit
import RxSwift

final class WakmusicRecommendReactor: Reactor {
    private var disposeBag: DisposeBag = DisposeBag()
    private var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase

    var initialState: State

    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateDataSource([RecommendPlaylistEntity])
        case updateLodingState(Bool)
        case showToast(String)
    }

    struct State {
        var dataSource: [RecommendPlaylistEntity]
        var isLoading: Bool
        @Pulse var toastMessage: String?
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return updateDataSource()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        case let .updateLodingState(isLoading):
            newState.isLoading = isLoading

        case let .showToast(message):
            newState.toastMessage = message
        }

        return newState
    }

    init(fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase) {
        LogManager.printDebug("✅ \(Self.self)")
        self.fetchRecommendPlaylistUseCase = fetchRecommendPlaylistUseCase
        self.initialState = State(
            dataSource: [],
            isLoading: true
        )
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self)")
    }
}

extension WakmusicRecommendReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLodingState(true)),
            fetchRecommendPlaylistUseCase
                .execute()
                .asObservable()
                .map { Mutation.updateDataSource($0) }
                .catch { error in
                    let wmErorr = error.asWMError
                    return Observable.just(
                        Mutation.showToast(wmErorr.errorDescription ?? LocalizationStrings.unknownErrorWarning)
                    )
                },
            .just(.updateLodingState(false))
        ])
    }

    func updateLoadnigState(isLoading: Bool) -> Observable<Mutation> {
        return .just(.updateLodingState(isLoading))
    }
}
