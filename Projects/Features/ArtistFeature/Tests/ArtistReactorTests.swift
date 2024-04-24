import ArtistDomainInterface
@testable import ArtistDomainTesting
@testable import ArtistFeature
import XCTest

final class ArtistReactorTests: XCTestCase {
    var fetchArtistListUseCase: FetchArtistListUseCaseSpy!
    var sut: ArtistReactor!

    override func setUp() {
        super.setUp()
        fetchArtistListUseCase = .init()
        sut = ArtistReactor(fetchArtistListUseCase: fetchArtistListUseCase)
    }

    override func tearDown() {
        super.tearDown()
        fetchArtistListUseCase = nil
        sut = nil
    }

    func test_when_viewDidLoad_action_and_artist_count_is_1_then_insert_hidden_item() {
        // Given
        let dummyArtistList = [makeTwoDummyArtistList().first!]
        fetchArtistListUseCase.handler = {
            return .just(dummyArtistList)
        }

        // When
        sut.action.onNext(.viewDidLoad)

        // Then
        XCTAssertEqual(fetchArtistListUseCase.callCount, 1)
        XCTAssertEqual(sut.currentState.artistList[0], dummyArtistList.first)
        XCTAssertEqual(sut.currentState.artistList[1].artistId, "")
        XCTAssertEqual(sut.currentState.artistList[1].isHiddenItem, true)
    }

    func test_when_viewDidLoad_action_and_artist_count_greater_than_2_then_swap_index_0_and_1() {
        // Given
        let dummyArtistList = makeTwoDummyArtistList()
        fetchArtistListUseCase.handler = {
            return .just(dummyArtistList)
        }
        let expectedArtistList = {
            var list = dummyArtistList
            list.swapAt(0, 1)
            return list
        }()

        // When
        sut.action.onNext(.viewDidLoad)

        // Then
        XCTAssertEqual(fetchArtistListUseCase.callCount, 1)
        XCTAssertEqual(sut.currentState.artistList, expectedArtistList)
    }

    private func makeTwoDummyArtistList() -> [ArtistListEntity] {
        [
            ArtistListEntity(
                artistId: "",
                name: "",
                short: "",
                group: "",
                title: "",
                description: "",
                color: [],
                youtube: "",
                twitch: "",
                instagram: "",
                imageRoundVersion: 0,
                imageSquareVersion: 0,
                graduated: false,
                isHiddenItem: true
            ),
            ArtistListEntity(
                artistId: "2",
                name: "nam2",
                short: "short2",
                group: "group2",
                title: "title2",
                description: "description2",
                color: [["ffffff"]],
                youtube: "https://youtube.com",
                twitch: "twitch",
                instagram: "insta",
                imageRoundVersion: 1,
                imageSquareVersion: 1,
                graduated: false,
                isHiddenItem: false
            )
        ]
    }
}
