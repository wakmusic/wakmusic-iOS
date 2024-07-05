import DesignSystem
import Foundation
import ReactorKit

final class DefaultPlaylistImageReactor: Reactor {
    enum Action {
        case viewDidload
    }

    enum Mutation {
        case updateDataSource([String])
    }

    struct State {
        var dataSource: [String]
    }

    var initialState: State

    init() {
        initialState = State(
            dataSource: []
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidload:
            return updateDataSource()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        }

        return newState
    }
}

extension DefaultPlaylistImageReactor {
    func updateDataSource() -> Observable<Mutation> {
        var dataSource: [String] = []

        for i in 0 ... 10 {
            dataSource.append("theme_\(i)")
        }

        return .just(.updateDataSource(dataSource))
    }
}
