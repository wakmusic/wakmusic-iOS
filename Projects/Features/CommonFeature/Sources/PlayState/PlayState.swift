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
    
    private let dummyPlayList = [
        SongEntity(id: "fgSXAKsq-Vo", title: "리와인드 (RE:WIND)", artist: "이세계아이돌", remix: "", reaction: "", views: 13442558, last: 0, date: "211222"),
        SongEntity(id: "wSG93VZoMFg", title: "[메타시그널 OST] In Romantic", artist: "해루석", remix: "", reaction: "", views: 320864, last: 0, date: "221216"),
        SongEntity(id: "kHpvUymXXEg", title: "KICK BACK #Shrots", artist: "왁컬로이두", remix: "", reaction: "", views: 887629, last: 0, date: "220216"),
        SongEntity(id: "rhOF0nwhEmU", title: "ANTIFRAGILE Challenge Vtuber Cover #Shorts", artist: "징버거", remix: "", reaction: "", views: 423708, last: 0, date: "221209"),
        SongEntity(id: "N2Tj_FMqlX8", title: "왁타버스 디즈니 메들리", artist: "비챤 X 고정멤버", remix: "", reaction: "", views: 864251, last: 0, date: "220722"),
        SongEntity(id: "tT-kuonVzfY", title: "STAY", artist: "징버거", remix: "", reaction: "", views: 1487185, last: 0, date: "230120"),
        SongEntity(id: "l8e1Byk1Dx0", title: "TRUE LOVER (트루러버)", artist: "해루석, 히키킹, 권민(ft.행주)", remix: "", reaction: "", views: 7075068, last: 0, date: "220918")
    ]
    
    init() {
        //playList = PlayList()
        playList = PlayList(list: dummyPlayList)
        currentSong = SongEntity(id: "fgSXAKsq-Vo", title: "리와인드 (RE:WIND)", artist: "이세계아이돌", remix: "", reaction: "", views: 13442558, last: 0, date: "211222")
        progress = PlayProgress()
        state = .unstarted
        repeatMode = .none
        shuffleMode = .off
        
        player = YouTubePlayer(source: .video(id: "fgSXAKsq-Vo"), configuration: .init(autoPlay: false, showControls: false, showRelatedVideos: false))
        
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
        
        playList.$list.sink { [weak self] list in
            guard let self else { return }
            guard let source = self.player.source?.id else { return }
            guard let index = list.firstIndex(where: { $0.id == source }) else { return }
            self.playList.currentPlayIndex = index
        }.store(in: &subscription)
        
    }
    
}
