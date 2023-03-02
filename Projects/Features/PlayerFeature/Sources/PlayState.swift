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
    
    @Published internal var player: YouTubePlayer
    @Published internal var state: YouTubePlayer.PlaybackState
    @Published internal var currentSong: SongEntity?
    @Published internal var progress: PlayProgress
    @Published internal var playList: PlayList
    
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

// MARK: YouTubePlayer 컨트롤과 관련된 메소드들을 모아놓은 익스텐션입니다.
extension PlayState {
    
    /// ⏯️ 현재 곡 재생
    func play() {
        self.player.play()
    }
    
    /// ▶️ 해당 곡 새로 재생
    func load(at song: SongEntity) {
        self.currentSong = song
        guard let currentSong = currentSong else { return }
        self.player.load(source: .video(id: currentSong.id))
    }
    
    /// ⏸️ 일시정지
    func pause() {
        self.player.pause()
    }

    /// ⏩ 다음 곡으로 변경 후 재생
    func forWard() {
        self.playList.next()
        self.currentSong = playList.current
        guard let currentSong = currentSong else { return }
        load(at: currentSong)
    }

    /// ⏪ 이전 곡으로 변경 후 재생
    func backWard() {
        self.playList.back()
        self.currentSong = playList.current
        guard let currentSong = currentSong else { return }
        load(at: currentSong)
    }

    /// ♻️ 첫번째 곡으로 변경 후 재생
    func playAgain() {
        self.playList.currentPlayIndex = 0
        self.currentSong = playList.first
        guard let currentSong = currentSong else { return }
        load(at: currentSong)
    }

}

// MARK: 커스텀 타입들을 모아놓은 익스텐션입니다.
extension PlayState {
    public class PlayList {
        var list: [SongEntity]
        var currentPlayIndex: Int // 현재 재생중인 노래 인덱스 번호

        init(list: [SongEntity] = []) {
            self.list = list
            currentPlayIndex = 0
        }

        var first: SongEntity? { return list.first }
        var last: SongEntity? { return list.last }
        var current: SongEntity? { return list[currentPlayIndex] }
        var count: Int { return list.count }
        var lastIndex: Int { return list.count - 1 }
        var isEmpty: Bool { return list.isEmpty }
        var isLast: Bool { return currentPlayIndex == lastIndex }

        func append(_ item: SongEntity) {
            list.append(item)
        }

        func insert(_ newElement: SongEntity, at: Int) {
            list.insert(newElement, at: at)
        }
        
        func remove(at: Int) {
            list.remove(at: at)
        }
        
        func removeAll() {
            list.removeAll()
        }

        func contains(_ item: SongEntity) -> Bool {
            return list.contains(item)
        }

        func back() {
            if currentPlayIndex == 0 { currentPlayIndex = lastIndex; return } // 현재 곡이 첫번째 곡이면 마지막 곡으로
            currentPlayIndex -= 1
        }

        func next() {
            if isLast { currentPlayIndex = 0; return } // 현재 곡이 마지막이면 첫번째 곡으로
            currentPlayIndex += 1
        }

        func uniqueAppend(item: SongEntity) {
            let uniqueIndex = uniqueIndex(of: item)

            if let uniqueIndex = uniqueIndex {
                self.currentPlayIndex = uniqueIndex
            } else { // 재생 목록에 없으면
                list.append(item) // 재생목록에 추가
                self.currentPlayIndex = self.lastIndex // index를 가장 마지막으로 옮김
            }
        }

        private func uniqueIndex(of item: SongEntity) -> Int? {
            // 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
            let index = list.enumerated().compactMap { $0.element == item ? $0.offset : nil }.first
            return index
        }

    }
    
    public struct PlayProgress {
        var currentProgress: Double = 0
        var endProgress: Double = 0
    }
}
