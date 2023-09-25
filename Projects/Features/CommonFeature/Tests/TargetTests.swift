import XCTest
import CommonFeature
import DomainModule

class TargetTests: XCTestCase {
    let givenList = [
        SongEntity(id: "", title: "제목1", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
        SongEntity(id: "", title: "제목2", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
        SongEntity(id: "", title: "제목3", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
        SongEntity(id: "", title: "제목4", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
        SongEntity(id: "", title: "제목5", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
        SongEntity(id: "", title: "제목6", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
        SongEntity(id: "", title: "제목7", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
    ].map { PlayListItem(item: $0) }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual("A", "A")
    }
    
    func testAppendSong() {
        // given
        var playState = PlayState(player: nil)
        var playList = playState.playList
        playList.list = givenList

        // when
        let testList = [
            SongEntity(id: "", title: "제목3", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목2", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목5", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목6", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
        ]
        playState.loadAndAppendSongsToPlaylist(testList)

        // then 147 3256
        let currentPlayIndex = playList.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex, 3)
        XCTAssertEqual(playList.list[2].item.title, "제목7")
        XCTAssertEqual(playList.list[3].item.title, "제목3")
        XCTAssertEqual(playList.list[4].item.title, "제목2")
        XCTAssertEqual(playList.list[5].item.title, "제목5")
        XCTAssertEqual(playList.list[6].item.title, "제목6")
    }

}
