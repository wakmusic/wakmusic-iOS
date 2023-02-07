//
//  AppComponent+Artist.swift
//  WaktaverseMusic
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule
import ArtistFeature

public extension AppComponent {
    
    var artistComponent: ArtistComponent {
        shared {
            ArtistComponent(parent: self)
        }
    }
    
    var remoteArtistDataSource: RemoteArtistDataSourceImpl {
        shared {
            RemoteArtistDataSourceImpl(keychain: keychain)
        }
    }
    var artistRepository: any ArtistRepository {
        shared {
            ArtistRepositoryImpl(remoteArtistDataSource: remoteArtistDataSource)
        }
    }
    
    var fetchArtistListUseCase: any FetchArtistListUseCase {
        
        shared {
            FetchArtistListUseCaseImpl(artistRepository: artistRepository)
        }
    }
}
