//
//  ArtistRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct UserRepositoryImpl: UserRepository {
 
   private let remoteUserDataSource: any RemoteUserDataSource
    
    public init(
        remoteUserDataSource: RemoteUserDataSource
    ) {
        self.remoteUserDataSource = remoteUserDataSource
    }
    
    public func fetchProfileList() -> Single<[ProfileListEntity]> {
        remoteUserDataSource.fetchProfileList()
    }

    public func setProfile(image: String) -> Single<BaseEntity> {
        remoteUserDataSource.setProfile(image: image)
    }
    
    public func setUserName(name: String) -> Single<BaseEntity> {
        remoteUserDataSource.setUserName(name: name)
    }
    
    public func fetchPlayList() -> Single<[PlayListEntity]> {
        remoteUserDataSource.fetchPlayList()
    }
    
    public func fetchFavoriteSongs() -> Single<[FavoriteSongEntity]> {
        remoteUserDataSource.fetchFavoriteSong()
    }
    
    public func editFavoriteSongsOrder(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.editFavoriteSongsOrder(ids: ids)
    }
    
    public func editPlayListOrder(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.editPlayListOrder(ids: ids)
    }
    
    public func deletePlayList(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.deletePlayList(ids: ids)
    }
    
    public func deleteFavoriteList(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.deleteFavoriteList(ids: ids)
    }
}
