//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule
import CommonFeature
import SignInFeature
import StorageFeature

//MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함


public extension AppComponent {
    
    var signInComponent : SignInComponent {
        SignInComponent(parent: self)
    }
    

    var storageComponent : StorageComponent {
        
        StorageComponent(parent: self)
        
    }
    
    var afterLoginComponent: AfterLoginComponent {
        
        AfterLoginComponent(parent: self)
    }
    
    var requestComponent: RequestComponent {
        RequestComponent(parent: self)
    }
    
   
    
    var remoteAuthDataSource: any RemoteAuthDataSource {
        shared {
            RemoteAuthDataSourceImpl(keychain: keychain)
        }
    }
    var authRepository: any AuthRepository {
        shared {
            AuthRepositoryImpl(remoteAuthDataSource: remoteAuthDataSource)
        }
    }
    
    
    var fetchTokenUseCase: any FetchTokenUseCase {
        
        shared {
            FetchTokenUseCaseImpl(authRepository: authRepository)
        }
    }
    
    var fetchNaverUserInfoUseCase: any FetchNaverUserInfoUseCase {
        
        shared {
            FetchNaverUserInfoUseCaseImpl(authRepository: authRepository)
        }
    }
    
        
}
