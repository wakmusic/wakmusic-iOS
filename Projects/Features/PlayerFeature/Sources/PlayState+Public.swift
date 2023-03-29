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
    /// 주어진 곡들을 재생목록에 추가하고 재생합니다.
    /// - 먼저 주어진 곡들의 첫번째 곡을 재생하며, 이후의 곡들은 재생목록의 마지막에 추가합니다.
    /// - Parameter duplicateAllowed: 재생목록 추가 시 중복 허용 여부 (기본값: false)
    func loadAndAppendSongs(_ songs: [SongEntity], duplicateAllowed: Bool = false) {
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
