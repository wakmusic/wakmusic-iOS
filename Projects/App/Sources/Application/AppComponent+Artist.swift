import ArtistDomain
import ArtistDomainInterface
import ArtistFeature
import ArtistFeatureInterface

public extension AppComponent {
    // MARK: Artist
    var artistFactory: any ArtistFactory {
        ArtistComponent(parent: self)
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

    // MARK: Artist Detail
    var artistDetailFactory: any ArtistDetailFactory {
        ArtistDetailComponent(parent: self)
    }

    var fetchArtistDetailUseCase: any FetchArtistDetailUseCase {
        shared {
            FetchArtistDetailUseCaseImpl(artistRepository: artistRepository)
        }
    }

    var fetchArtistSongListUseCase: any FetchArtistSongListUseCase {
        shared {
            FetchArtistSongListUseCaseImpl(artistRepository: artistRepository)
        }
    }

    var fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase {
        shared {
            FetchSubscriptionStatusUseCaseImpl(artistRepository: artistRepository)
        }
    }

    var subscriptionArtistUseCase: any SubscriptionArtistUseCase {
        shared {
            SubscriptionArtistUseCaseImpl(artistRepository: artistRepository)
        }
    }

    // MARK: Artist Detail > Artist Music
    var artistMusicComponent: ArtistMusicComponent {
        ArtistMusicComponent(parent: self)
    }

    // MARK: Artist Detail > Artist Music > Artist Music Content
    var artistMusicContentComponent: ArtistMusicContentComponent {
        ArtistMusicContentComponent(parent: self)
    }
}
