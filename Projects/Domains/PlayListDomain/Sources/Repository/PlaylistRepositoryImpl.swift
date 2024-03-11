//
//  ArtistRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomainInterface
import PlayListDomainInterface
import RxSwift

public final class PlayListRepositoryImpl: PlayListRepository {
    private let remotePlayListDataSource: any RemotePlayListDataSource

    public init(
        remotePlayListDataSource: RemotePlayListDataSource
    ) {
        self.remotePlayListDataSource = remotePlayListDataSource
    }

    public func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]> {
        remotePlayListDataSource.fetchRecommendPlayList()
    }

    public func fetchPlayListDetail(id: String, type: PlayListType) -> Single<PlayListDetailEntity> {
        remotePlayListDataSource.fetchPlayListDetail(id: id, type: type)
    }

    public func createPlayList(title: String) -> Single<PlayListBaseEntity> {
        remotePlayListDataSource.createPlayList(title: title)
    }

    public func editPlayList(key: String, songs: [String]) -> Single<BaseEntity> {
        return remotePlayListDataSource.editPlayList(key: key, songs: songs)
    }

    public func editPlayListName(key: String, title: String) -> Single<EditPlayListNameEntity> {
        remotePlayListDataSource.editPlayListName(key: key, title: title)
    }

    public func loadPlayList(key: String) -> Single<PlayListBaseEntity> {
        remotePlayListDataSource.loadPlayList(key: key)
    }

    public func addSongIntoPlayList(key: String, songs: [String]) -> Single<AddSongEntity> {
        remotePlayListDataSource.addSongIntoPlayList(key: key, songs: songs)
    }

    public func removeSongs(key: String, songs: [String]) -> RxSwift.Single<BaseEntity> {
        remotePlayListDataSource.removeSongs(key: key, songs: songs)
    }
}
