import XCTest
import CommonFeature
import DomainModule
import Combine

class TargetTests: XCTestCase {
    var playState = PlayState.shared
    var playlist = PlayState.shared.playList
    var subscription = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual("A", "A")
    }
    
    func testRemoveSong() {
        // given
        let list = [
            SongEntity(id: "", title: "제목1", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목2", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목3", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목4", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목5", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목6", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목7", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
        ].map { PlayListItem(item: $0) }
        
        playlist.list = list
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
        playlist.list = list
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
        let list = [
            SongEntity(id: "", title: "제목1", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목2", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목3", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목4", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목5", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목6", artist: "", remix: "", reaction: "", views: 0, last: 0, date: ""),
            SongEntity(id: "", title: "제목7", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
        ].map { PlayListItem(item: $0) }
        playlist.list = list
        
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
