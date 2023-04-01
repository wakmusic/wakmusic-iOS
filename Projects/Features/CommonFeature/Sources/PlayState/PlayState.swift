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
        
        
    }
    
}

// MARK: 커스텀 타입들을 모아놓은 익스텐션입니다.
extension PlayState {
    public class PlayList {
        public var list: [SongEntity]
        public var currentPlayIndex: Int // 현재 재생중인 노래 인덱스 번호
        
        init(list: [SongEntity] = []) {
            self.list = list
            currentPlayIndex = 0
        }
        
        public var first: SongEntity? { return list.first }
        public var last: SongEntity? { return list.last }
        public var current: SongEntity? { return list[currentPlayIndex] }
        public var count: Int { return list.count }
        public var lastIndex: Int { return list.count - 1 }
        public var isEmpty: Bool { return list.isEmpty }
        public var isLast: Bool { return currentPlayIndex == lastIndex }
        
        public func append(_ item: SongEntity) {
            list.append(item)
        }
        
        public func insert(_ newElement: SongEntity, at: Int) {
            list.insert(newElement, at: at)
        }
        
        public func remove(at: Int) {
            list.remove(at: at)
        }
        
        public func removeAll() {
            list.removeAll()
        }
        
        public   func contains(_ item: SongEntity) -> Bool {
            return list.contains(item)
        }
        
        public func back() {
            // 현재 곡이 첫번째 곡이면 마지막 곡으로
            if currentPlayIndex == 0 { currentPlayIndex = lastIndex; return }
            currentPlayIndex -= 1
        }
        
        public func next() {
            // 현재 곡이 마지막이면 첫번째 곡으로
            if isLast { currentPlayIndex = 0; return }
            currentPlayIndex += 1
        }
        
        public func reorderPlaylist(from: Int, to: Int) {
            let movedData = list[from]
            list.remove(at: from)
            list.insert(movedData, at: to)
            
            if currentPlayIndex == from {
                currentPlayIndex = to
            } else if currentPlayIndex > from && currentPlayIndex <= to {
                currentPlayIndex -= 1
            } else if currentPlayIndex < from && currentPlayIndex >= to {
                currentPlayIndex += 1
            }
        }
        
        public func uniqueIndex(of item: SongEntity) -> Int? {
            // 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
            for (index, song) in list.enumerated() {
                if song == item { return index }
            }
            return nil
        }
        
    }
    
    public struct PlayProgress {
        public var currentProgress: Double = 0
        public var endProgress: Double = 0
    }
}
