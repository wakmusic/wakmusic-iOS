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

public struct PlayListRepositoryImpl: PlayListRepository {
    
    
   
    
    private let remotePlayListDataSource: any RemotePlayListDataSource
    
    public init(
        remotePlayListDataSource: RemotePlayListDataSource
    ) {
        self.remotePlayListDataSource = remotePlayListDataSource
    }
    
    public func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]> {
        remotePlayListDataSource.fetchRecommendPlayList()
    }
    
    public func fetchPlayListDetail(id:String,type:PlayListType) -> Single<PlayListDetailEntity> {
        remotePlayListDataSource.fetchPlayListDetail(id: id, type: type)
    }
    
    public func createPlayList(title: String) -> Single<PlayListBaseEntity> {
        remotePlayListDataSource.createPlayList(title: title)
    }
    
    public func editPlayList(key: String,songs: [String]) -> Single<BaseEntity> {
        remotePlayListDataSource.editPlayList(key: key,songs: songs)
    }
    
    public func editPlayListName(key: String,title:String) -> Single<EditPlayListNameEntity> {
        remotePlayListDataSource.editPlayListName(key: key, title: title)
    }
    
    public func deletePlayList(key: String) -> Single<BaseEntity> {
        remotePlayListDataSource.deletePlayList(key: key)
    }
    
    public func loadPlayList(key: String) -> Single<PlayListBaseEntity> {
        remotePlayListDataSource.loadPlayList(key: key)
    }
   
}
