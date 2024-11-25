//
//  PlayState.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Combine
import Foundation
import LogManager
import SongsDomainInterface
import Utility

/// 완전히 도메인 로직으로 전환 고려
public final class PlayState: @unchecked Sendable {
    public static let shared = PlayState()
    private let playlist: Playlist
    private var subscription = Set<AnyCancellable>()
    public var count: Int { playlist.count }
    public var isEmpty: Bool { playlist.isEmpty }
    public var currentPlaylist: [PlaylistItem] { Array(playlist.list.uniqued()) }
    public var listChangedPublisher: AnyPublisher<[PlaylistItem], Never> { playlist.subscribeListChanges() }

    private init() {
        let playedList = RealmManager.shared.fetchRealmDB(PlaylistLocalEntity.self)
            .toArray(type: PlaylistLocalEntity.self)
            .map { PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist) }

        self.playlist = Playlist(list: playedList)
        subscribePlayListChanges()
    }

    deinit {
        LogManager.printDebug("🚀:: \(Self.self) deinit")
        NotificationCenter.default.removeObserver(self)
    }

    /// 플레이리스트에 변경사항이 생겼을 때, 로컬 DB를 덮어씁니다.
    private func subscribePlayListChanges() {
        playlist.subscribeListChanges()
            .map { Array($0) }
            .sink { [weak self] playlistItems in
                LogManager.setUserProperty(property: .playlistSongTotal(count: playlistItems.count))
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
        if let existSongIndexs = self.uniqueIndex(of: item) {
            self.remove(indexs: [existSongIndexs])
        }
        playlist.append(item)
    }

    public func append(contentsOf items: [PlaylistItem]) {
        let existSongIndexs = items.compactMap { self.uniqueIndex(of: $0) }
        playlist.remove(indexs: existSongIndexs)
        let mappedSongs = items.uniqueElements
        playlist.append(mappedSongs)
    }

    public func insert(_ item: PlaylistItem, at index: Int) {
        if let existSongIndexs = self.uniqueIndex(of: item) {
            self.remove(indexs: [existSongIndexs])
        }
        playlist.insert(item, at: index)
    }

    public func update(contentsOf: [PlaylistItem]) {
        playlist.update(contentsOf: contentsOf)
    }

    public func remove(id: String) {
        playlist.remove(id: id)
    }

    public func remove(ids: [String]) {
        ids.forEach { playlist.remove(id: $0) }
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

    func removeAll(where shouldBeRemoved: (PlaylistItem) -> Bool) {
        playlist.removeAll(where: shouldBeRemoved)
    }

    public func contains(item: PlaylistItem) -> Bool {
        return playlist.contains(item)
    }

    public func contains(id: String) -> Bool {
        return playlist.contains(id: id)
    }

    public func reorderPlaylist(from: Int, to: Int) {
        playlist.reorderPlaylist(from: from, to: to)
    }

    public func uniqueIndex(of item: PlaylistItem) -> Int? {
        return playlist.uniqueIndex(of: item)
    }
}
