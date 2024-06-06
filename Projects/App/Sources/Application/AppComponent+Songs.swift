import BaseFeature
import HomeFeature
import LyricHighlightingFeature
import SongsDomain
import SongsDomainInterface
import LyricHighlightingFeatureInterface

public extension AppComponent {
    var homeComponent: HomeComponent {
        HomeComponent(parent: self)
    }

    var newSongsComponent: NewSongsComponent {
        NewSongsComponent(parent: self)
    }

    var newSongsContentComponent: NewSongsContentComponent {
        NewSongsContentComponent(parent: self)
    }

    var lyricHighlightingFactory: any LyricHighlightingFactory {
        LyricHighlightingComponent(parent: self)
    }

    var lyricDecoratingComponent: LyricDecoratingComponent {
        LyricDecoratingComponent(parent: self)
    }

    var remoteSongsDataSource: any RemoteSongsDataSource {
        shared {
            RemoteSongsDataSourceImpl(keychain: keychain)
        }
    }

    var songsRepository: any SongsRepository {
        shared {
            SongsRepositoryImpl(remoteSongsDataSource: remoteSongsDataSource)
        }
    }

    var fetchLyricsUseCase: any FetchLyricsUseCase {
        shared {
            FetchLyricsUseCaseImpl(songsRepository: songsRepository)
        }
    }

    var fetchNewSongsUseCase: any FetchNewSongsUseCase {
        shared {
            FetchNewSongsUseCaseImpl(songsRepository: songsRepository)
        }
    }
}
