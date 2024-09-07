import PriceDomainInterface
import ReactorKit

final class PlaylistCoverOptionPopupReactor: Reactor {
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateDataSource([PlaylistCoverOptionModel])
        case updateLoadingState(Bool)
    }

    struct State {
        var dataSource: [PlaylistCoverOptionModel]
        var isLoading: Bool
    }

    private let fetchPlaylistImagePriceUsecase: any FetchPlaylistImagePriceUseCase
    var initialState: State

    init(fetchPlaylistImagePriceUsecase: any FetchPlaylistImagePriceUseCase) {
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

extension PlaylistCoverOptionPopupReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),

            fetchPlaylistImagePriceUsecase
                .execute()
                .asObservable()
                .flatMap { entity -> Observable<Mutation> in
                    return Observable.just(
                        Mutation.updateDataSource([
                            PlaylistCoverOptionModel(title: "이미지 선택", price: 0),
                            PlaylistCoverOptionModel(title: "앨범에서 고르기", price: entity.price)
                        ])
                    )
                },
            .just(.updateLoadingState(false))
        ])
    }
}
