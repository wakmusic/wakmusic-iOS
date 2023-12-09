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

public struct LikeRepositoryImpl: LikeRepository {
    
    private let remoteLikeDataSource: any RemoteLikeDataSource
    
    public init(
        remoteLikeDataSource: RemoteLikeDataSource
    ) {
        self.remoteLikeDataSource = remoteLikeDataSource
    }
    
    public func fetchLikeNumOfSong(id: String) -> Single<LikeEntity> {
        remoteLikeDataSource.fetchLikeNumOfSong(id: id)
    }
    
    public func addLikeSong(id: String) -> Single<LikeEntity> {
        remoteLikeDataSource.addLikeSong(id: id)
    }
    
    public func cancelLikeSong(id: String) -> Single<LikeEntity> {
        remoteLikeDataSource.cancelLikeSong(id: id)
    }
    
    
}
