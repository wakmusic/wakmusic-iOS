import BaseFeature
import ReactorKit
import SongsDomainInterface
import Utility

final class SongCreditReactor: Reactor {
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case creditSelected(worker: CreditModel.CreditWorker)
    }

    enum Mutation {
        case updateCredits([CreditModel])
        case updateNavigateType(NavigateType?)
    }

    enum NavigateType {
        case back
        case creditDetail(name: String)
    }

    struct State {
        var backgroundImageURL: String
        var credits: [CreditModel]
        var navigateType: NavigateType?
    }

    var initialState: State
    private let songID: String
    private let fetchSongCreditsUseCase: any FetchSongCreditsUseCase

    init(
        songID: String,
        fetchSongCreditsUseCase: any FetchSongCreditsUseCase
    ) {
        self.songID = songID
        self.fetchSongCreditsUseCase = fetchSongCreditsUseCase

        let backgroundImageURL = YoutubeURLGenerator().generateHDThumbnailURL(id: songID)
        self.initialState = .init(
            backgroundImageURL: backgroundImageURL,
            credits: []
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()

        case .backButtonDidTap:
            return self.navigate(to: .back)

        case let .creditSelected(worker):
            return self.navigate(to: .creditDetail(name: worker.name))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateCredits(credits):
            newState.credits = credits

        case let .updateNavigateType(navigateType):
            newState.navigateType = navigateType
        }

        return newState
    }
}

private extension SongCreditReactor {
    func viewDidLoad() -> Observable<Mutation> {
        return fetchSongCreditsUseCase.execute(id: songID)
            .map { credits in
                credits.map { CreditModel(position: $0.type, names: $0.names) }
            }
            .map { Mutation.updateCredits($0) }
            .asObservable()
    }
}

private extension SongCreditReactor {
    func navigate(to destination: NavigateType) -> Observable<Mutation> {
        return .concat(
            .just(.updateNavigateType(destination)),
            .just(.updateNavigateType(nil))
        )
    }
}
