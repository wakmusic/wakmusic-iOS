import CommonFeature
import DomainModule
import XCTest

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
}
