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
    func loadAndAppendSongsToPlaylist(_ songs: [SongEntity], duplicateAllowed: Bool = false) {
        guard let firstSong = songs.first else { return }
        
        if let uniqueIndex = self.playList.uniqueIndex(of: firstSong) {
            self.playList.currentPlayIndex = uniqueIndex
        } else {
            self.playList.append(firstSong)
            self.playList.currentPlayIndex = self.playList.lastIndex
        }
        if self.state == .cued {
            self.switchPlayerMode(to: .mini)
        }
        self.load(at: firstSong)
        
        songs.dropFirst().forEach { song in
            if self.playList.uniqueIndex(of: song) == nil {
                self.playList.append(song)
            }
        }
    }
    
    /// 주어진 곡들을 재생목록에 추가합니다.
    /// - Parameter duplicateAllowed: 재생목록 추가 시 중복 허용 여부 (기본값: false)
    func appendSongsToPlaylist(_ songs: [SongEntity], duplicateAllowed: Bool = false) {
        songs.forEach { song in
            if self.playList.uniqueIndex(of: song) == nil {
                self.playList.append(song)
            }
        }
        if self.state == .cued {
            self.switchPlayerMode(to: .mini)
            guard let song = songs.first else { return }
            self.player.cue(source: .video(id: song.id))
            self.currentSong = song
        }
    }
}
