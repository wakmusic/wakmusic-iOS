//
//  PlayState+YoutubePlayer.swift
//  CommonFeature
//
//  Created by YoungK on 2023/04/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule

// MARK: YouTubePlayer 컨트롤과 관련된 메소드들을 모아놓은 익스텐션입니다.
extension PlayState {
    
    /// ⏯️ 현재 곡 재생
    public func play() {
        self.player.play()
    }
    
    /// ⏸️ 일시정지
    public func pause() {
        self.player.pause()
    }
    
    /// ⏹️ 플레이어 닫기
    public func stop() {
        self.player.stop()
        self.currentSong = nil
        self.progress.clear()
        self.playList.list.removeAll()
    }
    
    /// ▶️ 해당 곡 새로 재생
    public func load(at song: SongEntity) {
        self.currentSong = song
        guard let currentSong = currentSong else { return }
        self.player.load(source: .video(id: currentSong.id))
    }
    
    /// ▶️ 플레이리스트의 해당 위치의  곡 재생
    public func loadInPlaylist(at index: Int) {
        self.playList.currentPlayIndex = index
        self.currentSong = self.playList.current
        guard let currentSong = currentSong else { return }
        load(at: currentSong)
    }
    
    /// ⏩ 다음 곡으로 변경 후 재생
    public func forward() {
        self.playList.next()
        self.currentSong = playList.current
        guard let currentSong = currentSong else { return }
        load(at: currentSong)
    }
    
    /// ⏪ 이전 곡으로 변경 후 재생
    public func backward() {
        self.playList.back()
        self.currentSong = playList.current
        guard let currentSong = currentSong else { return }
        load(at: currentSong)
    }
    
    /// 🔀 플레이리스트 내 랜덤 재생
    public func shufflePlay() {
        let shuffledIndices = self.playList.list.indices.shuffled()
        if let index = shuffledIndices.first(where: { $0 != self.playList.currentPlayIndex }) {
            self.loadInPlaylist(at: index)
        } else {
            self.forward()
        }
    }
    
    /// ♻️ 첫번째 곡으로 변경 후 재생
    public func playAgain() {
        self.playList.currentPlayIndex = 0
        self.currentSong = playList.first
        guard let currentSong = currentSong else { return }
        load(at: currentSong)
    }
    
}
