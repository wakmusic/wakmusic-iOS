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
    
    
    
    var remoteLikeDataSource: any RemoteLikeDataSource {
        shared {
            RemoteLikeDataSourceImpl(keychain: keychain)
        }
    }
    
    var likeRepository: any LikeRepository {
        shared {
            LikeRepositoryImpl(remoteLikeDataSource: remoteLikeDataSource)
        }
    }
    
    var fetchLikeNumOfSongUseCase: any FetchLikeNumOfSongUseCase {
        
        shared {
            FetchLikeNumOfSongUseCaseImpl(likeRepository: likeRepository)
        }
        
        
    }
    
    var addLikeSongUseCase: any AddLikeSongUseCase {
        
        shared {
            AddLikeSongUseCaseImpl(likeRepository: likeRepository)
        }
        
        
    }
    
    var cancelLikeSongUseCase: any CancelLikeSongUseCase {
        
        shared {
            CancelLikeSongUseCaseImpl(likeRepository: likeRepository)
        }
        
        
    }
    
   
    
    
}
