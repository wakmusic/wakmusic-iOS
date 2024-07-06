import DesignSystem
import Foundation
import ReactorKit

final class DefaultPlaylistImageReactor: Reactor {
    enum Action {
        case viewDidload
        case selectedIndex(Int)
    }

    enum Mutation {
        case updateDataSource([String])
        case updateSelectedItem(Int)
    }

    struct State {
        var dataSource: [String]
        var selectedIndex: Int
    }

    var initialState: State

    init() {
        initialState = State(
            dataSource: [],
            selectedIndex: 0
        )
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
        }

        return newState
    }
}

extension DefaultPlaylistImageReactor {
    func updateDataSource() -> Observable<Mutation> {
        var dataSource: [String] = []

        for i in 0 ... 100 {
            dataSource.append("theme_\(i)")
        }

        return .just(.updateDataSource(dataSource))
    }
}
