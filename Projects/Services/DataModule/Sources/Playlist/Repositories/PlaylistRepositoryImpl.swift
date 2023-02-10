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
    
    public func fetchRecommendPlayLists() -> Single<[RecommendPlayListEntity]> {
        remotePlayListDataSource.fetchRecommendPlayList()
    }
    
   
}
