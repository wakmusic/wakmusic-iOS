//
//  PlaylistTests.swift
//  CommonFeature
//
//  Created by YoungK on 2023/09/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import XCTest
import DomainModule
import CommonFeature

final class PlaylistTests: XCTestCase {
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
    
    func testRemoveSong() {
        // given
        var playList = PlayList(list: givenList)
        playList.changeCurrentPlayIndex(to: 2)

        // when
        playList.remove(indexs: [1, 2, 4, 5])

        // then
        var currentPlayIndex = playList.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex , 1)
        XCTAssertEqual(playList.count, 3)
        XCTAssertEqual(playList.list[0].item.title, "제목1")
        XCTAssertEqual(playList.list[1].item.title, "제목4")

        // given
        playList = PlayList(list: givenList)
        playList.changeCurrentPlayIndex(to: playList.lastIndex)

        // when
        playList.remove(indexs: [4, 5, 6])

        // then
        currentPlayIndex = playList.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex , 0)
        XCTAssertEqual(playList.count, 4)
        XCTAssertEqual(playList.list[0].item.title, "제목1")
        XCTAssertEqual(playList.list[1].item.title, "제목2")
    }

    func testRorderSong() {
        // given
        var playList = PlayList(list: givenList)
        playList.list[0].isPlaying = true
        
        // when
        playList.reorderPlaylist(from: 2, to: 1)

        // then
        var currentPlayIndex = playList.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex, 0)

        // when
        playList.reorderPlaylist(from: 0, to: 6)

        // then
        currentPlayIndex = playList.currentPlayIndex ?? -1
        XCTAssertEqual(currentPlayIndex, 6)
    }

}
