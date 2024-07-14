//
//  PlayState.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Combine
import Foundation
import SongsDomainInterface
import Utility

/// 완전히 도메인 로직으로 전환 고려
public final class PlayState {
    public static let shared = PlayState()
    private var playlist: Playlist
    private var subscription = Set<AnyCancellable>()
    public var count: Int { playlist.count }
    public var isEmpty: Bool { playlist.isEmpty }
    public var currentPlaylist: [PlaylistItem] { playlist.list }
    public var listChangedPublisher: AnyPublisher<[PlaylistItem], Never> { playlist.subscribeListChanges() }

    private init() {
        let playedList = RealmManager.shared.fetchRealmDB(PlaylistLocalEntity.self)
            .toArray(type: PlaylistLocalEntity.self)
            .map { PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist) }

        self.playlist = Playlist(list: playedList)
        subscribePlayListChanges()
    }

    deinit {
        DEBUG_LOG("🚀:: \(Self.self) deinit")
        NotificationCenter.default.removeObserver(self)
    }

    /// 플레이리스트에 변경사항이 생겼을 때, 로컬 DB를 덮어씁니다.
    private func subscribePlayListChanges() {
        playlist.subscribeListChanges()
            .sink { [weak self] playlistItems in
                self?.updatePlaylistChangesToLocalDB(playList: playlistItems)
            }
            .store(in: &subscription)
    }

    private func updatePlaylistChangesToLocalDB(playList: [PlaylistItem]) {
        let allPlayedLists = RealmManager.shared.fetchRealmDB(PlaylistLocalEntity.self)
        RealmManager.shared.deleteRealmDB(model: allPlayedLists)

        let playedList = playList.map {
            PlaylistLocalEntity(
                id: $0.id,
                title: $0.title,
                artist: $0.artist
            )
        }
        RealmManager.shared.addRealmDB(model: playedList)
    }

    public func fetchPlayListFromLocalDB() -> [PlaylistItem] {
        let playedList = RealmManager.shared.fetchRealmDB(PlaylistLocalEntity.self)
            .toArray(type: PlaylistLocalEntity.self)
            .map {
                PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist)
            }
        return playedList
    }

    public func append(item: PlaylistItem) {
        playlist.append(item)
    }

    public func append(contentsOf items: [PlaylistItem]) {
        playlist.append(items)
    }

    public func insert(_ item: PlaylistItem, at index: Int) {
        playlist.insert(item, at: index)
    }

    public func update(contentsOf: [PlaylistItem]) {
        playlist.update(contentsOf: contentsOf)
    }

    public func remove(at index: Int) {
        playlist.remove(at: index)
    }

    public func remove(indexs: [Int]) {
        playlist.remove(indexs: indexs)
    }

    public func removeAll() {
        playlist.removeAll()
    }

    public func contains(item: PlaylistItem) -> Bool {
        return playlist.contains(item)
    }

    public func reorderPlaylist(from: Int, to: Int) {
        playlist.reorderPlaylist(from: from, to: to)
    }

    public func uniqueIndex(of item: PlaylistItem) -> Int? {
        return playlist.uniqueIndex(of: item)
    }
}
