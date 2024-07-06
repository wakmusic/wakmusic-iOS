//
//  PlayState.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AVFAudio
import Combine
import Foundation
import SongsDomainInterface
import Utility

/// 완전히 도메인 로직으로 전환 고려
public final class PlayState {
    public static let shared = PlayState()
    @Published public var playList: Playlist
    private var subscription = Set<AnyCancellable>()

    public init() {
        DEBUG_LOG("🚀:: \(Self.self) initialized")
        self.playList = Playlist()
        self.playList.list = fetchPlayListFromLocalDB()
        subscribePlayListChanges()
    }

    deinit {
        DEBUG_LOG("🚀:: \(Self.self) deinit")
        NotificationCenter.default.removeObserver(self)
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
            self.updatePlaylistChangesToLocalDB(playList: playListItems)
        }
        .store(in: &subscription)
    }

    public func updatePlaylistChangesToLocalDB(playList: [PlaylistItem]) {
        let allPlayedLists = RealmManager.shared.fetchRealmDB(PlaylistLocalEntity.self)
        RealmManager.shared.deleteRealmDB(model: allPlayedLists)

        let playedList = playList.map {
            PlaylistLocalEntity(
                id: $0.id,
                title: $0.title,
                artist: $0.artist,
                date: $0.date
            )
        }
        RealmManager.shared.addRealmDB(model: playedList)
    }

    public func fetchPlayListFromLocalDB() -> [PlaylistItem] {
        let playedList = RealmManager.shared.fetchRealmDB(PlaylistLocalEntity.self)
            .toArray(type: PlaylistLocalEntity.self)
            .map {
                PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist, date: $0.date)
            }
        return playedList
    }
}
