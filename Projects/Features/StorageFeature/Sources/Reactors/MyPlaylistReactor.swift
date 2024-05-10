import Foundation
import LogManager
import ReactorKit
import RxSwift

final class MyPlaylistReactor: Reactor {
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case fetchDataSource([MyPlayListSectionModel])
    }

    struct State {
        var isEditing: Bool
        var dataSource: [MyPlayListSectionModel]
    }

    var initialState: State

    init() {
        self.initialState = State (
            isEditing: false,
            dataSource: []
        )
    }

    deinit {
        LogManager.printDebug("❌ Deinit \(Self.self)")
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            fetchDataSource()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .fetchDataSource(dataSource):
            newState.dataSource = dataSource
        }

        return newState
    }
}

extension MyPlaylistReactor {
    func fetchDataSource() -> Observable<Mutation> {
        return .just(.fetchDataSource([]))
    }
}
