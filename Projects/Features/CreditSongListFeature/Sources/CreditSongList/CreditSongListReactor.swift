import ReactorKit

final class CreditSongListReactor: Reactor {
    enum Action {}
    enum Mutation {}
    struct State {
        var workerName: String
    }

    let initialState: State
    internal let workerName: String

    init(workerName: String) {
        self.initialState = .init(
            workerName: workerName
        )
        self.workerName = workerName
    }

    func mutate(action: Action) -> Observable<Mutation> {
        .empty()
    }

    func reduce(state: State, mutation: Mutation) -> State {
        state
    }
}
