//
//  PlayState.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule
import YouTubePlayerKit
import Combine

final public class PlayState {
    public static let shared = PlayState()
    
    @Published public var player: YouTubePlayer
    @Published public var state: YouTubePlayer.PlaybackState
    @Published public var currentSong: SongEntity?
    @Published public var progress: PlayProgress
    @Published public var playList: PlayList
    @Published public var repeatMode: RepeatMode
    @Published public var shuffleMode: ShuffleMode
    
    private var subscription = Set<AnyCancellable>()
    
    init() {
        playList = PlayList()
        progress = PlayProgress()
        state = .unstarted
        repeatMode = .none
        shuffleMode = .off
        player = YouTubePlayer(configuration: .init(autoPlay: false, showControls: false, showRelatedVideos: false))
                
        player.playbackStatePublisher.sink { [weak self] state in
            guard let self = self else { return }
            self.state = state
        }.store(in: &subscription)
        
        player.currentTimePublisher().sink { [weak self] currentTime in
            guard let self = self else { return }
            self.progress.currentProgress = currentTime
        }.store(in: &subscription)
        
        player.durationPublisher.sink { [weak self] duration in
            guard let self = self else { return }
            self.progress.endProgress = duration
        }.store(in: &subscription)
        
    }
    
}
