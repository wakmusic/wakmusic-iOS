import DesignSystem
import Foundation
import ImageDomainInterface
import ReactorKit
import RxSwift

#warning("디폴트 이미지 가져오기")
final class DefaultPlaylistCoverReactor: Reactor {
    enum Action {
        case viewDidload
        case selectedIndex(Int)
    }

    enum Mutation {
        case updateDataSource([DefaultImageEntity])
        case updateSelectedItem(Int)
        case updateLoadingState(Bool)
    }

    struct State {
        var dataSource: [DefaultImageEntity]
        var selectedIndex: Int
        var isLoading: Bool
    }

    private let fetchDefaultPlaylistImageUseCase: any FetchDefaultPlaylistImageUseCase
    var initialState: State

    init(fetchDefaultPlaylistImageUseCase: any FetchDefaultPlaylistImageUseCase) {
        initialState = State(
            dataSource: [],
            selectedIndex: 0,
            isLoading: true
        )

        self.fetchDefaultPlaylistImageUseCase = fetchDefaultPlaylistImageUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidload:
            return updateDataSource()

        case let .selectedIndex(index):
            return .just(.updateSelectedItem(index))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        case let .updateSelectedItem(id):
            newState.selectedIndex = id
        case let .updateLoadingState(flag):
            newState.isLoading = flag
        }

        return newState
    }
}

extension DefaultPlaylistCoverReactor {
    func updateDataSource() -> Observable<Mutation> {
        return .concat([
            .just(.updateLoadingState(true)),
            fetchDefaultPlaylistImageUseCase.execute()
                .asObservable()
                .flatMap { data -> Observable<Mutation> in
                    return Observable.just(.updateDataSource(data))
                },
            .just(.updateLoadingState(false))
        ])
    }
}
