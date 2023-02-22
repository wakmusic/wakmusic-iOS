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
import SearchFeature

public extension AppComponent {
    
    var searchComponent: SearchComponent {
         
            SearchComponent(parent: self)
        
    }
    
    var afterSearchComponent: AfterSearchComponent {
        
        AfterSearchComponent(parent: self)
    }
    
    var afterSearchContentComponent: AfterSearchContentComponent {
        
        AfterSearchContentComponent(parent: self)
    }
    
    var remoteSearchDataSource: any RemoteSearchDataSource {
        shared {
            RemoteSearchDataSourceImpl(keychain: keychain)
        }
    }
    var songsRepository: any SongsRepository {
        shared {
            SongsRepositoryImpl(remoteSearchDataSource:remoteSearchDataSource)
        }
    }
    var fetchSearchSongUseCase: any FetchSearchSongUseCase {

        shared {
           FetchSearchSongUseCaseImpl(songsRepository: songsRepository)
        }
    }
    var fetchLyricsUseCase: any FetchLyricsUseCase {
        
        shared {
            FetchLyricsUseCaseImpl(songsRepository: songsRepository)
        }
    }
}
