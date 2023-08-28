import XCTest
import CommonFeature
import DomainModule
import Combine

class TargetTests: XCTestCase {
    var playState = PlayState.shared
    var playlist = PlayState.shared.playList
    var subscription = Set<AnyCancellable>()
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
        playlist.list = givenList
        
        // when
        let testList = [
            SongEntity(id: "", title: "제목3", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목2", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목5", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목6", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
        ]
        playState.loadAndAppendSongsToPlaylist(testList)
        
        // then 147 3256
        let currentPlayIndex = playlist.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex, 3)
        XCTAssertEqual(playlist.list[2].item.title, "제목7")
        XCTAssertEqual(playlist.list[3].item.title, "제목3")
        XCTAssertEqual(playlist.list[4].item.title, "제목2")
        XCTAssertEqual(playlist.list[5].item.title, "제목5")
        XCTAssertEqual(playlist.list[6].item.title, "제목6")
    }
    
    func testRemoveSong() {
        // given
        playlist.list = givenList
        playlist.changeCurrentPlayIndex(to: 2)
        
        // when
        playlist.remove(indexs: [1, 2, 4, 5])
        
        // then
        var currentPlayIndex = playlist.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex , 1)
        XCTAssertEqual(playlist.count, 3)
        XCTAssertEqual(playlist.list[0].item.title, "제목1")
        XCTAssertEqual(playlist.list[1].item.title, "제목4")
        
        // given
        playlist.list = givenList
        playlist.changeCurrentPlayIndex(to: playlist.lastIndex)
        
        // when
        playlist.remove(indexs: [4, 5, 6])
        
        // then
        currentPlayIndex = playlist.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex , 0)
        XCTAssertEqual(playlist.count, 4)
        XCTAssertEqual(playlist.list[0].item.title, "제목1")
        XCTAssertEqual(playlist.list[1].item.title, "제목2")
    }
    
    func testRorderSong() {
        // given
        playlist.list = givenList
        
        // when
        playlist.reorderPlaylist(from: 2, to: 1)
        
        // then
        var currentPlayIndex = playlist.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex, 0)
        
        // when
        playlist.reorderPlaylist(from: 0, to: 6)
        
        // then
        currentPlayIndex = playlist.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex, 6)
        
    }

}
