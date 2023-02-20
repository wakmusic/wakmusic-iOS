//
//  AppComponent+Home.swift
//  WaktaverseMusic
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule
import HomeFeature

public extension AppComponent {
    
    //MARK: Home
    var homeComponent: HomeComponent {
        HomeComponent(parent: self)
    }
    
    var remoteNewSongDataSource: RemoteNewSongDataSourceImpl {
        shared {
            RemoteNewSongDataSourceImpl(keychain: keychain)
        }
    }
    
    var homeRepository: any HomeRepository {
        shared {
            HomeRepositoryImpl(remoteNewSongDataSource: remoteNewSongDataSource)
        }
    }
    
    var fetchNewSongUseCase: any FetchNewSongUseCase {
        shared {
            FetchNewSongUseCaseImpl(homeRepository: homeRepository)
        }
    }
}
