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
        case creditDetail(worker: CreditModel.CreditWorker)
    }

    struct State {
        var backgroundImageURL: BackgroundImageModel
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

        let backgroundImageHDURL = YoutubeURLGenerator().generateHDThumbnailURL(id: songID)
        let backgroundImageURL = YoutubeURLGenerator().generateThumbnailURL(id: songID)

        self.initialState = .init(
            backgroundImageURL: BackgroundImageModel(
                imageURL: backgroundImageHDURL,
                alternativeImageURL: backgroundImageURL
            ),
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

            return self.navigate(to: .creditDetail(worker: worker))
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
                let filteredCredits = credits.map { entity in
                    SongCreditsEntity(
                        type: entity.type,
                        names: entity.names.filter { !$0.name.isEmpty }
                    )
                }
                return filteredCredits.map { CreditModel(creditEntity: $0) }
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
