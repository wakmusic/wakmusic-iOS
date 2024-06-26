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

    var myPlayListComponent: MyPlayListComponent {
        MyPlayListComponent(parent: self)
    }

    var playlistFactory: any PlaylistFactory {
        PlaylistComponent(parent: self)
    }

    var remotePlayListDataSource: any RemotePlayListDataSource {
        shared {
            RemotePlayListDataSourceImpl(keychain: keychain)
        }
    }

    var playListRepository: any PlaylistRepository {
        shared {
            PlaylistRepositoryImpl(remotePlayListDataSource: remotePlayListDataSource)
        }
    }

    var fetchRecommendPlaylistUseCase: any FetchRecommendPlayListUseCase {
        shared {
            FetchRecommendPlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var fetchPlaylistDetailUseCase: any FetchPlayListDetailUseCase {
        shared {
            FetchPlayListDetailUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var createPlaylistUseCase: any CreatePlayListUseCase {
        shared {
            CreatePlayListUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var updatePlaylistUseCase: any UpdatePlaylistUseCase {
        shared {
            UpdatePlaylistUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase {
        shared {
            UpdateTitleAndPrivateUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase {
        shared {
            AddSongIntoPlaylistUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var removeSongsUseCase: any RemoveSongsUseCase {
        shared {
            RemoveSongsUseCaseImpl(playListRepository: playListRepository)
        }
    }

    var uploadPlaylistImageUseCase: any UploadPlaylistImageUseCase {
        shared {
            UploadPlaylistImageUseCaseImpl(playListRepository: playListRepository)
        }
    }
}
