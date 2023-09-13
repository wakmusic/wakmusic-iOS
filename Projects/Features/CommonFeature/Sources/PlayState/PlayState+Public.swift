//
//  PlayState+Public.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule
import Utility
import UIKit
import YouTubePlayerKit

public extension PlayState {
    /// 주어진 곡들을 재생목록에 추가하고 재생합니다.
    /// - 먼저 주어진 곡들의 첫번째 곡을 재생하며, 이후의 곡들은 재생목록의 마지막에 추가합니다.
    /// - Parameter duplicateAllowed: 재생목록 추가 시 중복 허용 여부 (기본값: false)
    func loadAndAppendSongsToPlaylist(_ songs: [SongEntity], duplicateAllowed: Bool = false) {
        if songs.isEmpty { return }
        // 1. 이미 있는 곡들 인덱스 찾기
        // 2. 리스트에서 해당 인덱스들 곡 삭제
        // 3. 리스트 뒤에 곡들 추가
        // 4. currentPlayIndex 변경
        // 5. 주어진 첫번째 곡 재생
        let existSongIndexs = songs.uniqueElements.compactMap { self.playList.uniqueIndex(of: PlayListItem(item: $0)) }
        self.playList.remove(indexs: existSongIndexs)
        let mappedSongs = songs.uniqueElements.map { PlayListItem(item: $0) }
        self.playList.append(mappedSongs)
        
        if let firstSong = mappedSongs.first, let playSongIndex = self.playList.uniqueIndex(of: firstSong) {
            if self.playerMode == .close { self.switchPlayerMode(to: .mini) }
            self.playList.changeCurrentPlayIndex(to: playSongIndex)
            self.load(at: firstSong.item)
        }
    }
    
    /// 주어진 곡들을 재생목록에 추가합니다.
    /// - Parameter duplicateAllowed: 재생목록 추가 시 중복 허용 여부 (기본값: false)
    func appendSongsToPlaylist(_ songs: [SongEntity], duplicateAllowed: Bool = false) {
        let existSongIndexs = songs.uniqueElements.compactMap { self.playList.uniqueIndex(of: PlayListItem(item: $0)) }
        self.playList.remove(indexs: existSongIndexs)
        let mappedSongs = songs.uniqueElements.map { PlayListItem(item: $0) }
        self.playList.append(mappedSongs)
        
        if self.playerMode == .close {
            self.switchPlayerMode(to: .mini)
            self.currentSong = self.playList.currentPlaySong
            if let currentSong = currentSong {
                self.player?.cue(source: .video(id: currentSong.id))
            }
        }
    }
    
    /// 플레이어의 상태를 체크합니다.
    func checkForPlayerState(completion: ((YouTubePlayer.State) -> Void)? = nil) {
        guard let playerState = self.player?.state else { return }
        completion?(playerState)
    }
    
    /// 플레이어를 리셋합니다.
    func resetPlayer() {
        self.player = YouTubePlayer(configuration: .init(autoPlay: false, showControls: false, showRelatedVideos: false))
        self.player?.cue(source: .video(id: self.currentSong?.id ?? ""))
        NotificationCenter.default.post(name: .resetYouTubePlayerHostingView, object: nil)
    }
}
