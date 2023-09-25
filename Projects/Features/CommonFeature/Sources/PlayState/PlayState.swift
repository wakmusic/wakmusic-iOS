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
import Utility
import AVFAudio

final public class PlayState {
    public static let shared = PlayState()
    
    @Published public var player: YouTubePlayer?
    @Published public var state: YouTubePlayer.PlaybackState = .unstarted
    @Published public var currentSong: SongEntity?
    @Published public var progress: PlayProgress
    @Published public var playList: PlayList
    @Published public var repeatMode: RepeatMode = .none
    @Published public var shuffleMode: ShuffleMode = .off
    @Published public var playerMode: PlayerMode = .mini

    private var subscription = Set<AnyCancellable>()
    
    public init(player: YouTubePlayer?, playList: PlayList, playProgress: PlayProgress, fetchPlayListFromLocalDB: () -> [PlayListItem]) {
        DEBUG_LOG("🚀:: \(Self.self) initialized")
        self.player = player
        self.playList = playList
        self.progress = playProgress
        
        self.playList.list = fetchPlayListFromLocalDB()
        currentSong = playList.currentPlaySong
        self.player?.cue(source: .video(id: currentSong?.id ?? "")) // 곡이 있으면 .cued 없으면 .unstarted
        
        subscribePlayPublisher()
        subscribePlayListChanges()
        registerAudioRouteChangeNotification()
    }
    
    convenience public init() {
        self.init(player: YouTubePlayer(configuration: .init(autoPlay: false, showControls: false, showRelatedVideos: false)), playList: PlayList(), playProgress: PlayProgress(), fetchPlayListFromLocalDB: { return [] })
    }
    convenience public init(player: YouTubePlayer?) {
        self.init(player: player, playList: PlayList(), playProgress: PlayProgress(), fetchPlayListFromLocalDB: { return [] })
    }
    
    deinit {
        DEBUG_LOG("🚀:: \(Self.self) deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    public func subscribePlayPublisher() {
        player?.playbackStatePublisher.sink { [weak self] state in
            guard let self = self else { return }
            self.state = state
        }.store(in: &subscription)
        
        player?.currentTimePublisher().sink { [weak self] currentTime in
            guard let self = self else { return }
            self.progress.currentProgress = currentTime
        }.store(in: &subscription)
        
        player?.durationPublisher.sink { [weak self] duration in
            guard let self = self else { return }
            self.progress.endProgress = duration
        }.store(in: &subscription)
    }
    
    /// 플레이리스트에 변경사항이 생겼을 때, 로컬 DB를 덮어씁니다.
    public func subscribePlayListChanges() {
        Publishers.Merge4(
            playList.listAppended,
            playList.listRemoved,
            playList.listReordered,
            playList.currentPlayIndexChanged
        )
        .sink { [weak self] playListItems in
            guard let self else { return }
            self.updatePlayListChangesToLocalDB(playList: playListItems)
        }.store(in: &subscription)
        
        playList.currentPlaySongChanged.sink { [weak self] song in
            guard let self else { return }
            self.currentSong = song
            if let index = self.playList.currentPlayIndex {
                loadInPlaylist(at: index)
            }
        }.store(in: &subscription)
    }
    
    public func updatePlayListChangesToLocalDB(playList: [PlayListItem]) {
        let allPlayedLists = RealmManager.shared.realm.objects(PlayedLists.self)
        RealmManager.shared.deleteRealmDB(model: allPlayedLists)
        
        let playedList = playList.map {
            PlayedLists(
                id: $0.item.id,
                title: $0.item.title,
                artist: $0.item.artist,
                remix: $0.item.remix,
                reaction: $0.item.reaction,
                views: $0.item.views,
                last: $0.item.last,
                date: $0.item.date,
                lastPlayed: $0.isPlaying
            )}
        RealmManager.shared.addRealmDB(model: playedList)
    }
    
    public func fetchPlayListFromLocalDB() -> [PlayListItem] {
        let playedList = RealmManager.shared.realm.objects(PlayedLists.self)
            .toArray(type: PlayedLists.self)
            .map { PlayListItem(item:
                SongEntity(
                    id: $0.id,
                    title: $0.title,
                    artist: $0.artist,
                    remix: $0.remix,
                    reaction: $0.reaction,
                    views: $0.views,
                    last: $0.last,
                    date: $0.date),
                    isPlaying: $0.lastPlayed
            )}
        return playedList
    }
    
    /// 디바이스와 연결된 오디오 장치가 변경되었음을 감지합니다.
    public func registerAudioRouteChangeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange(notification:)),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
    }
    
    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
            
        case .unknown:
            DEBUG_LOG("🚀unknown")
            
        case .newDeviceAvailable: //이어폰 꼈을때,
            DEBUG_LOG("🚀newDeviceAvailable")
            
        case .oldDeviceUnavailable: //이어폰 뺐을때 .oldDeviceUnavailable, .categoryChange 두 가지가 간헐적으로 꽂힘
            let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
            let previousOutput = previousRoute?.outputs.first
            let portType = previousOutput?.portType
            
            if portType == AVAudioSession.Port.headphones || portType == AVAudioSession.Port.bluetoothA2DP {
                // 이어폰 또는 블루투스 이어폰이 연결 해제됨
                DEBUG_LOG("🚀oldDeviceUnavailable 이어폰이 연결 해제되었습니다.")
                self.pause()
            }
            
        case .categoryChange: //이어폰 뺐을때 .oldDeviceUnavailable, .categoryChange 두 가지가 간헐적으로 꽂힘
            let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
            let previousOutput = previousRoute?.outputs.first
            let portType = previousOutput?.portType
            
            if portType == AVAudioSession.Port.headphones || portType == AVAudioSession.Port.bluetoothA2DP {
                // 이어폰 또는 블루투스 이어폰이 연결 해제됨
                DEBUG_LOG("🚀categoryChange 이어폰이 연결 해제되었습니다.")
                self.pause()
            }
            
        case .override:
            DEBUG_LOG("🚀override")
            
        case .wakeFromSleep:
            DEBUG_LOG("🚀wakeFromSleep")
            
        case .noSuitableRouteForCategory:
            DEBUG_LOG("🚀noSuitableRouteForCategory")
            
        case .routeConfigurationChange:
            DEBUG_LOG("🚀routeConfigurationChange")
            
        default:
            return
        }
    }
}
