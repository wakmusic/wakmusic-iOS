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

public struct AuthRepositoryImpl: AuthRepository {
   
    
    
    


    private let remoteAuthDataSource: any RemoteAuthDataSource
    
    public init(remoteAuthDataSource: RemoteAuthDataSource) {
        self.remoteAuthDataSource = remoteAuthDataSource
    }
    
    
    public func fetchToken(id: String, type: ProviderType) -> Single<AuthLoginEntity> {
        remoteAuthDataSource.fetchToken(id: id, type: type)
    }
    
    public func fetchNaverUserInfo(tokenType: String, accessToken: String) -> RxSwift.Single<DomainModule.NaverUserInfoEntity> {
        remoteAuthDataSource.fetchNaverUserInfo(tokenType: tokenType, accessToken: accessToken)
    }
    
    public func fetchUserInfo(token: String) -> Single<AuthUserInfoEntity> {
        remoteAuthDataSource.fetchUserInfo(token: token)
    }
    
    public func withdrawUserInfo(token: String) -> Single<BaseEntity> {
        remoteAuthDataSource.withdrawUserInfo(token: token)
    }
    
    
    
    
   
}
