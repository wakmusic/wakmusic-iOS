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

public extension PlayState {
    /// 주어진 곡들을 재생목록에 추가하고 재생합니다.
    /// - 먼저 주어진 곡들의 첫번째 곡을 재생하며, 이후의 곡들은 재생목록의 마지막에 추가합니다.
    /// - Parameter duplicateAllowed: 재생목록 추가 시 중복 허용 여부 (기본값: false)
    func loadAndAppendSongsToPlaylist(_ songs: [SongEntity], duplicateAllowed: Bool = false) {
        guard let firstSong = songs.first else { return }
        let uniqueIndex = self.playList.uniqueIndex(of: PlayListItem(item: firstSong))
        
        if let uniqueIndex {
            self.playList.changeCurrentPlayIndex(to: uniqueIndex)
        } else {
            self.playList.append(PlayListItem(item: firstSong))
            self.playList.changeCurrentPlayIndex(to: self.playList.lastIndex)
        }
        
        if self.playerMode == .close {
            self.switchPlayerMode(to: .mini)
        }
        self.load(at: firstSong)
        
        let songsWithoutFirst = songs.dropFirst()
        if songsWithoutFirst.isEmpty { return }
        
        let notDuplicatedSongs = songsWithoutFirst.compactMap { song in
            return self.playList.uniqueIndex(of:PlayListItem(item: song)) == nil ? PlayListItem(item: song) : nil
        }
        self.playList.append(notDuplicatedSongs)
        
    }
    
    /// 주어진 곡들을 재생목록에 추가합니다.
    /// - Parameter duplicateAllowed: 재생목록 추가 시 중복 허용 여부 (기본값: false)
    func appendSongsToPlaylist(_ songs: [SongEntity], duplicateAllowed: Bool = false) {
        let notDuplicatedSongs = songs.compactMap { song in
            return self.playList.uniqueIndex(of:PlayListItem(item: song)) == nil ? PlayListItem(item: song) : nil
        }
        self.playList.append(notDuplicatedSongs)
        
        if self.playerMode == .close {
            self.switchPlayerMode(to: .mini)
            self.currentSong = self.playList.currentPlaySong
            if let currentSong = currentSong {
                self.player.cue(source: .video(id: currentSong.id))
            }
        }
    }
    
    /// 플레이어의 상태를 체크하여 출력합니다. (For DEBUG)
    func checkForPlayerState() {
    #if DEBUG
        guard let playerState = PlayState.shared.player.state else { return }
        switch playerState {
        case .idle:
            DEBUG_LOG("PlayState.shared.player.state: idle")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIApplication.shared.windows.first?.rootViewController?.showToast(
                    text: "PlayState.shared.player.state: idle",
                    font: UIFont.systemFont(ofSize: 14, weight: .medium)
                )
            }
        case .ready:
            DEBUG_LOG("PlayState.shared.player.state: ready")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIApplication.shared.windows.first?.rootViewController?.showToast(
                    text: "PlayState.shared.player.state: ready",
                    font: UIFont.systemFont(ofSize: 14, weight: .medium)
                )
            }
        case let .error(error):
            DEBUG_LOG("PlayState.shared.player.state: error: \(error.localizedDescription)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIApplication.shared.windows.first?.rootViewController?.showToast(
                    text: error.localizedDescription,
                    font: UIFont.systemFont(ofSize: 14, weight: .medium)
                )
            }
        }
    #endif
    }
}
