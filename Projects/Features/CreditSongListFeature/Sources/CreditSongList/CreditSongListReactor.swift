import CreditDomainInterface
import ReactorKit

final class CreditSongListReactor: Reactor {
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateProfileImageURL(String?)
    }

    struct State {
        var workerName: String
        var profileImageURL: String?
    }

    let initialState: State
    internal let workerName: String
    private let fetchCreditProfileImageURLUseCase: FetchCreditProfileImageURLUseCase

    init(
        workerName: String,
        fetchCreditProfileImageURLUseCase: FetchCreditProfileImageURLUseCase
    ) {
        self.initialState = .init(
            workerName: workerName
        )
        self.workerName = workerName
        self.fetchCreditProfileImageURLUseCase = fetchCreditProfileImageURLUseCase
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
        case let .updateProfileImageURL(url):
            newState.profileImageURL = url
        }

        return newState
    }
}

private extension CreditSongListReactor {
    func viewDidLoad() -> Observable<Mutation> {
        fetchCreditProfileImageURLUseCase
            .execute(name: workerName)
            .map { Mutation.updateProfileImageURL($0) }
            .asObservable()
    }
}
