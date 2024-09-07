import ArtistDomainInterface
import ReactorKit
import Utility

public final class ArtistReactor: Reactor {
    public enum Action {
        case viewDidLoad
    }

    public enum Mutation {
        case updateArtistList([ArtistEntity])
    }

    public struct State {
        var artistList: [ArtistEntity]
    }

    public var initialState: State

    private let fetchArtistListUseCase: any FetchArtistListUseCase

    init(
        fetchArtistListUseCase: any FetchArtistListUseCase
    ) {
        self.fetchArtistListUseCase = fetchArtistListUseCase
        self.initialState = .init(
            artistList: []
        )
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return viewDidLoad()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateArtistList(artistList):
            newState.artistList = artistList
        }
        return newState
    }
}

// MARK: - Mutate
private extension ArtistReactor {
    func viewDidLoad() -> Observable<Mutation> {
        return fetchArtistListUseCase.execute()
            .catchAndReturn([])
            .asObservable()
            .map { [weak self] artistList in
                guard let self, !artistList.isEmpty else {
                    DEBUG_LOG("데이터가 없습니다.")
                    return artistList
                }
                var newArtistList = artistList

                // Waterfall Grid UI가 기본적으로 왼쪽부터 쌓이게 되기에 첫번째 Cell을 hide 시킵니다
                if newArtistList.count == 1 {
                    let hiddenItem: ArtistEntity = self.makeHiddenArtistEntity()
                    newArtistList.insert(hiddenItem, at: 0)
                } else {
                    newArtistList.swapAt(0, 1)
                }
                return newArtistList
            }
            .map(Mutation.updateArtistList)
    }
}

// MARK: - Reusable
private extension ArtistReactor {
    func makeHiddenArtistEntity() -> ArtistEntity {
        ArtistEntity(
            id: "",
            krName: "",
            enName: "",
            groupName: "",
            title: "",
            description: "",
            personalColor: "",
            roundImage: "",
            squareImage: "",
            graduated: false,
            playlist: .init(latest: "", popular: "", oldest: ""),
            isHiddenItem: false
        )
    }
}
