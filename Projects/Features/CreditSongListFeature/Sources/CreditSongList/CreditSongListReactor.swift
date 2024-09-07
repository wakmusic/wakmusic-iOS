import CreditDomainInterface
import ReactorKit

final class CreditSongListReactor: Reactor {
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateProfile(CreditProfileEntity)
    }

    struct State {
        var workerName: String
        var profile: CreditProfileEntity
    }

    let initialState: State
    internal let workerName: String
    private let fetchCreditProfileUseCase: FetchCreditProfileUseCase

    init(
        workerName: String,
        fetchCreditProfileUseCase: FetchCreditProfileUseCase
    ) {
        self.initialState = .init(
            workerName: workerName,
            profile: .init(name: "", imageURL: nil)
        )
        self.workerName = workerName
        self.fetchCreditProfileUseCase = fetchCreditProfileUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateProfile(data):
            newState.profile = data
        }

        return newState
    }
}

private extension CreditSongListReactor {
    func viewDidLoad() -> Observable<Mutation> {
        fetchCreditProfileUseCase
            .execute(name: workerName)
            .map { Mutation.updateProfile($0) }
            .asObservable()
    }
}
