//
//  AppComponent+Play.swift
//  WaktaverseMusic
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule

public extension AppComponent {
    var remotePlayDataSource: any RemotePlayDataSource {
        shared {
            RemotePlayDataSourceImpl(keychain: keychain)
        }
    }
    
    var playRepository: any PlayRepository {
        shared {
            PlayRepositoryImpl(remotePlayDataSource:remotePlayDataSource)
        }
    }
    
    var postPlaybackLogUseCase: any PostPlaybackLogUseCase {
        shared {
          PostPlaybackLogUseCaseImpl(playRepository: playRepository)
        }
    }
}
