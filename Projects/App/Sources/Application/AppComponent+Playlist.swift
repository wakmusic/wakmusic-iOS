import BaseFeature
import BaseFeatureInterface
import PlaylistDomain
import PlaylistDomainInterface
import PlaylistFeature
import PlaylistFeatureInterface
import StorageFeature

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var playlistPresenterGlobalState: PlayListPresenterGlobalStateProtocol {
        shared {
            PlayListPresenterGlobalState()
        }
    }

    var playlistDetailFactory: any PlaylistDetailFactory {
        PlaylistDetailComponent(parent: self)
    }

    var playlistStorageComponent: PlaylistStorageComponent {
        PlaylistStorageComponent(parent: self)
    }

    var playlistFactory: any PlaylistFactory {
        PlaylistComponent(parent: self)
    }

    var myPlaylistDetailFactory: any MyPlaylistDetailFactory {
        MyPlaylistDetailComponent(parent: self)
    }

    var remotePlaylistDataSource: any RemotePlaylistDataSource {
        shared {
            RemotePlaylistDataSourceImpl(keychain: keychain)
        }
    }

    var playlistRepository: any PlaylistRepository {
        shared {
            PlaylistRepositoryImpl(remotePlaylistDataSource: remotePlaylistDataSource)
        }
    }

    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase {
        shared {
            FetchRecommendPlaylistUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase {
        shared {
            FetchPlaylistDetailUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var createPlaylistUseCase: any CreatePlaylistUseCase {
        shared {
            CreatePlaylistUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var updatePlaylistUseCase: any UpdatePlaylistUseCase {
        shared {
            UpdatePlaylistUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase {
        shared {
            UpdateTitleAndPrivateUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase {
        shared {
            AddSongIntoPlaylistUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var removeSongsUseCase: any RemoveSongsUseCase {
        shared {
            RemoveSongsUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var uploadPlaylistImageUseCase: any UploadPlaylistImageUseCase {
        shared {
            UploadPlaylistImageUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var subscribePlaylistUseCase: any SubscribePlaylistUseCase {
        shared {
            SubscribePlaylistUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var unSubscribePlaylistUseCase: any UnSubscribePlaylistUseCase {
        shared {
            UnSubscribePlaylistUseCaseImpl(playlistRepository: playlistRepository)
        }
    }
}
