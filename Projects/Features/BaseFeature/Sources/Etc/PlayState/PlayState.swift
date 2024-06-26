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

public final class PlayState {
    public static let shared = PlayState()
    @Published public var playList: PlayList
    private var subscription = Set<AnyCancellable>()

    public init(
        playList: PlayList = PlayList()
    ) {
        DEBUG_LOG("🚀:: \(Self.self) initialized")
        self.playList = playList
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
        }.store(in: &subscription)
    }

    public func updatePlaylistChangesToLocalDB(playList: [PlayListItem]) {
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
            )
        }
        RealmManager.shared.addRealmDB(model: playedList)
    }

    public func fetchPlayListFromLocalDB() -> [PlayListItem] {
        let playedList = RealmManager.shared.realm.objects(PlayedLists.self)
            .toArray(type: PlayedLists.self)
            .map { PlayListItem(
                item:
                SongEntity(
                    id: $0.id,
                    title: $0.title,
                    artist: $0.artist,
                    remix: $0.remix,
                    reaction: $0.reaction,
                    views: $0.views,
                    last: $0.last,
                    date: $0.date
                ),
                isPlaying: $0.lastPlayed
            ) }
        return playedList
    }
}
