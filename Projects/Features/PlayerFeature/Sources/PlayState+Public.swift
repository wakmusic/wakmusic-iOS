//
//  PlayState+Public.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule

public extension PlayState {
    /// 주어진 곡을 재생목록에 중복되지 않게 추가하고 재생합니다.
    func loadAndAppendUniqueSong(_ song: SongEntity) {
        self.playList.appendIfUnique(item: song)
        self.load(at: song)
    }
    
    /// 주어진 곡들을 재생목록에 중복되지 않게 추가하고 재생합니다.
    /// - 먼저 주어진 곡들의 첫번째 곡을 재생하며, 이후의 곡들은 중복 여부를 검사하여 재생목록의 마지막에 추가합니다.
    func loadAndAppendUniqueSongs(_ songs: [SongEntity]) {
        if let firstSong = songs.first {
            self.playList.appendIfUnique(item: firstSong)
            self.load(at: firstSong)
        }
        songs.dropFirst().forEach { song in
            self.playList.appendIfUnique(item: song)
        }
    }
    
    /// 주어진 곡들을 재생목록에 중복되지 않게 추가합니다.
    func appendUniqueSongs(_ songs: [SongEntity]) {
        songs.forEach { self.playList.appendIfUnique(item: $0) }
    }
}
