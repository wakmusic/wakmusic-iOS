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

    func test_when_viewDidLoad_action_and_artist_count_is_1_then_insert_zero_index_hidden_item() {
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
        XCTAssertEqual(sut.currentState.artistList[0].id, "")
        XCTAssertEqual(sut.currentState.artistList[0].isHiddenItem, false)
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

    private func makeTwoDummyArtistList() -> [ArtistEntity] {
        [
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
            ),
            ArtistEntity(
                id: "2",
                krName: "nam2",
                enName: "eng2",
                groupName: "group2",
                title: "title2",
                description: "description2",
                personalColor: "ffffff",
                roundImage: "",
                squareImage: "",
                graduated: false,
                playlist: .init(latest: "", popular: "", oldest: ""),
                isHiddenItem: false
            )
        ]
    }
}
