//
//  PlayState.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import YoutubeKit

final public class PlayState {
    public static let shared = PlayState()
    
    internal var player: YTSwiftyPlayer
    internal var state: YTSwiftyPlayerState
    internal var currentSong: String?
    internal var progress: BehaviorSubject<PlayProgress>
    internal var playList: PlayList
    
    private let disposeBag = DisposeBag()
    init() {
        currentSong = "wSG93VZoMFg"
        progress = BehaviorSubject(value: PlayProgress.init(currentProgress: 0, endProgress: 0))
        playList = PlayList()
        playList.list = ["wSG93VZoMFg", "jzt_aR_PSGo", "Gce2fYnlw0w", "UMIP5k1QvW8", "tT-kuonVzfY"]
        state = .unstarted
        
        player = YTSwiftyPlayer(
            frame: .init(x: 0, y: 0, width: 320, height: 180),
            playerVars: [
                .playsInline(true),
                .videoID(currentSong ?? ""),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(false)
            ])
        
        player.delegate = self
        let playerPath = PlayerFeatureResources.bundle.path(forResource: "YoutubePlayer", ofType: "html")!
        let htmlString = (try? String(contentsOfFile: playerPath, encoding: .utf8)) ?? ""
        player.loadPlayerHTML(htmlString)
        
        
    }
    
}

// MARK: YouTubePlayer 컨트롤과 관련된 메소드들을 모아놓은 익스텐션입니다.
extension PlayState {
    
    /// ⏯️ 현재 곡 재생
    func play() {
        guard currentSong != nil else { return }
        self.player.playVideo()
    }
    
    /// ▶️ 해당 곡 새로 재생
    func load(at song: String) {
        currentSong = song
        guard let currentSong = currentSong else { return }
        self.player.loadVideo(videoID: currentSong)
    }
    
    /// ⏸️ 일시정지
    func pause() {
        self.player.pauseVideo()
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
        var list: [String]
        var currentPlayIndex: Int // 현재 재생중인 노래 인덱스 번호

        init() {
            list = [String]()
            currentPlayIndex = 0
        }

        var first: String? { return list.first }
        var last: String? { return list.last }
        var current: String? { return list[currentPlayIndex] }
        var count: Int { return list.count }
        var lastIndex: Int { return list.count - 1 }
        var isEmpty: Bool { return list.isEmpty }
        var isLast: Bool { return currentPlayIndex == lastIndex }

        func append(_ item: String) {
            list.append(item)
        }

        func removeAll() {
            list.removeAll()
        }

        func contains(_ item: String) -> Bool {
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

        func uniqueAppend(item: String) {
            let uniqueIndex = uniqueIndex(of: item)

            if let uniqueIndex = uniqueIndex {
                self.currentPlayIndex = uniqueIndex
            } else { // 재생 목록에 없으면
                list.append(item) // 재생목록에 추가
                self.currentPlayIndex = self.lastIndex // index를 가장 마지막으로 옮김
            }
        }

        private func uniqueIndex(of item: String) -> Int? {
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

extension PlayState: YTSwiftyPlayerDelegate {
    public func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        print("new state:", state)
        self.state = state
    }
    
    public func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
        
    }
    
    public func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        
    }
    
    public func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
        self.progress.onNext(PlayProgress(currentProgress: currentTime, endProgress: player.duration ?? 0))
    }
    
    public func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
        
    }
    
    public func playerReady(_ player: YTSwiftyPlayer) {
        
    }
    
    public func apiDidChange(_ player: YTSwiftyPlayer) {
        print("apiDidChange")
    }
    
    public func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
        
    }
    
    public func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
        
    }
}
