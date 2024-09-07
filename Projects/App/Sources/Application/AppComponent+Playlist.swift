import BaseFeature
import BaseFeatureInterface
import ImageDomain
import ImageDomainInterface
import PlaylistDomain
import PlaylistDomainInterface
import PlaylistFeature
import PlaylistFeatureInterface
import StorageFeature

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol {
        shared {
            PlayListPresenterGlobalState()
        }
    }

    var playlistDetailFactory: any PlaylistDetailFactory {
        PlaylistDetailComponent(parent: self)
    }

    var playlistFactory: any PlaylistFactory {
        PlaylistComponent(parent: self)
    }

    var myPlaylistDetailFactory: any MyPlaylistDetailFactory {
        MyPlaylistDetailComponent(parent: self)
    }

    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory {
        UnknownPlaylistDetailComponent(parent: self)
    }

    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory {
        WakmusicPlaylistDetailComponent(parent: self)
    }

    var playlistCoverOptionPopupFactory: any PlaylistCoverOptionPopupFactory {
        PlaylistCoverOptionPopupComponent(parent: self)
    }

    var checkPlaylistCoverFactory: any CheckPlaylistCoverFactory {
        CheckPlaylistCoverComponent(parent: self)
    }

    var defaultPlaylistCoverFactory: any DefaultPlaylistCoverFactory {
        DefaultPlaylistCoverComponent(parent: self)
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

    var fetchPlaylistSongsUseCase: any FetchPlaylistSongsUseCase {
        shared {
            FetchPlaylistSongsUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase {
        shared {
            FetchPlaylistDetailUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var fetchWMPlaylistDetailUseCase: any FetchWMPlaylistDetailUseCase {
        shared {
            FetchWMPlaylistDetailUseCaseImpl(playlistRepository: playlistRepository)
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

    var subscribePlaylistUseCase: any SubscribePlaylistUseCase {
        shared {
            SubscribePlaylistUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var checkSubscriptionUseCase: any CheckSubscriptionUseCase {
        shared {
            CheckSubscriptionUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var uploadDefaultPlaylistImageUseCase: any UploadDefaultPlaylistImageUseCase {
        shared {
            UploadDefaultPlaylistImageUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var requestCustomImageURLUseCase: any RequestCustomImageURLUseCase {
        shared {
            RequestCustomImageURLUseCaseImpl(playlistRepository: playlistRepository)
        }
    }

    var requestPlaylistOwnerIDUsecase: any RequestPlaylistOwnerIDUsecase {
        shared {
            RequestPlaylistOwnerIDUsecaseImpl(playlistRepository: playlistRepository)
        }
    }
}
