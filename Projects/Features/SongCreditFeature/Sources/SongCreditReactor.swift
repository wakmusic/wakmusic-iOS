import BaseFeature
import ReactorKit
import SongsDomainInterface
import Utility

final class SongCreditReactor: Reactor {
    enum Action {
        case viewDidLoad
    }
    enum Mutation {
        case updateCredits([CreditModel])
    }
    struct State {
        var backgroundImageURL: String
        var credits: [CreditModel]
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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateCredits(credits):
            newState.credits = credits
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
