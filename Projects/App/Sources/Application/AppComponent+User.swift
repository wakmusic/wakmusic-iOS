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
    

   
    
    var profileComponent:  ProfilePopComponent {
        ProfilePopComponent(parent: self)
    }
   
    
    var remoteUserDataSource: any RemoteUserDataSource {
        shared {
            RemoteUserDataSourceImpl(keychain: keychain)
        }
    }
    var userRepository: any UserRepository {
        shared {
            UserRepositoryImpl(remoteUserDataSource: remoteUserDataSource)
        }
    }
    
    
    var setProfileUseCase: any SetProfileUseCase {
        
        shared {
            SetProfileUseCaseImpl(userRepository: userRepository)
        }
        
    }
    
    var setUserNameUseCase: any SetUserNameUseCase {
        
        shared{
            SetUserNameUseCaseImpl(userRepository: userRepository)
        }
    }
    
    
    
    
   
    
  
    
}
