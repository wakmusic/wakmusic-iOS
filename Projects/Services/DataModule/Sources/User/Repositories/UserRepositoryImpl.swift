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
    
    
    public func setProfile(token: String, image: String) -> Single<BaseEntity> {
        remoteUserDataSource.setProfile(token: token, image: image)
    }
    
    public func setUserName(token: String, name: String) -> Single<BaseEntity> {
        remoteUserDataSource.setUserName(token: token, name: name)
    }
    
    public func fetchSubPlayList(token: String) -> Single<[SubPlayListEntity]> {
        remoteUserDataSource.fetchSubPlayList(token: token)
    }
    
    public func fetchFavoriteSongs(token: String) -> Single<[FavoriteSongEntity]> {
        remoteUserDataSource.fetchFavoriteSong(token: token)
    }
    
 
}
