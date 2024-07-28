import PriceDomainInterface
import ReactorKit

final class ThumbnailPopupReactor: Reactor {
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateDataSource([ThumbnailOptionModel])
        case updateLoadingState(Bool)
    }

    struct State {
        var dataSource: [ThumbnailOptionModel]
        var isLoading: Bool
    }

    private let fetchPlaylistImagePriceUsecase: any FetchPlaylistImagePriceUsecase
    var initialState: State

    init(fetchPlaylistImagePriceUsecase: any FetchPlaylistImagePriceUsecase) {
        self.fetchPlaylistImagePriceUsecase = fetchPlaylistImagePriceUsecase
        initialState = State(
            dataSource: [],
            isLoading: true
        )
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

        case let .updateLoadingState(flag):
            newState.isLoading = flag
        }

        return newState
    }
}

extension ThumbnailPopupReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),

            fetchPlaylistImagePriceUsecase
                .execute()
                .asObservable()
                .flatMap { entity -> Observable<Mutation> in
                    return Observable.just(
                        Mutation.updateDataSource([
                            ThumbnailOptionModel(title: "이미지 선택", cost: 0),
                            ThumbnailOptionModel(title: "앨범에서 고르기", cost: entity.price)
                        ])
                    )
                },
            .just(.updateLoadingState(false))
        ])
    }
}
