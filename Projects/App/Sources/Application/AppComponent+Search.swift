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
        shared {
            SearchComponent(parent: self)
        }
    }
    
    var remoteChartDataSource: any RemoteSearchDataSource {
        shared {
            RemoteSearchDataSourceImpl(keychain: keychain)
        }
    }
    var searchRepository: any SearchRepository {
        shared {
            SearchRepositoryImpl(remoteSearchDataSource:remoteChartDataSource)
        }
    }
    var fetchSearchSongUseCase: any FetchSearchSongUseCase {
        
        shared {
           FetchSearchSongUseCaseImpl(searchRepository: searchRepository)
        }
    }
}
