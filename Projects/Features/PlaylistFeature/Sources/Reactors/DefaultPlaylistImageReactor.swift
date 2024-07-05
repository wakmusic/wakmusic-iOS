import DesignSystem
import Foundation
import ReactorKit

final class DefaultPlaylistImageReactor: Reactor {
    enum Action {
        case viewDidload
        case select(String)
    }

    enum Mutation {
        case updateDataSource([String])
        case updateSelectedItem(String)
        
    }

    struct State {
        var dataSource: [String]
        var selectedItem: String
    }

    var initialState: State

    init() {
        initialState = State(
            dataSource: [],
            selectedItem: ""
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidload:
            return updateDataSource()
        
        case let .select(id):
            return .just(.updateSelectedItem(id))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        case let .updateSelectedItem(id):
            newState.selectedItem = id
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
