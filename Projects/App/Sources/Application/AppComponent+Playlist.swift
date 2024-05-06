//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import BaseFeatureInterface
import PlayListDomain
import PlayListDomainInterface
import PlaylistFeature
import PlaylistFeatureInterface
import StorageFeature

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var playlistDetailFactory: any PlaylistDetailFactory {
        PlayListDetailComponent(parent: self)
    }

    var myPlayListComponent: MyPlayListComponent {
        MyPlayListComponent(parent: self)
    }

    var remotePlayListDataSource: any RemotePlayListDataSource {
        shared {
            RemotePlayListDataSourceImpl(keychain: keychain)
        }
    }

    var playListRepository: any PlayListRepository {
        shared {
            PlayListRepositoryImpl(remotePlayListDataSource: remotePlayListDataSource)
        }
    }

    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase {
        shared {
            FetchRecommendPlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase {
        shared {
            FetchPlayListDetailUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var createPlayListUseCase: any CreatePlayListUseCase {
        shared {
            CreatePlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var editPlayListUseCase: any EditPlayListUseCase {
        shared {
            EditPlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var editPlayListNameUseCase: any EditPlayListNameUseCase {
        shared {
            EditPlayListNameUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var loadPlayListUseCase: any LoadPlayListUseCase {
        shared {
            LoadPlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var addSongIntoPlayListUseCase: any AddSongIntoPlayListUseCase {
        shared {
            AddSongIntoPlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var removeSongsUseCase: any RemoveSongsUseCase {
        shared {
            RemoveSongsUseCaseImpl(playListRepository: playListRepository)
        }
    }
}
