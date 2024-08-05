import BaseFeature
import HomeFeature
import HomeFeatureInterface
import LyricHighlightingFeature
import LyricHighlightingFeatureInterface
import MusicDetailFeature
import MusicDetailFeatureInterface
import SongsDomain
import SongsDomainInterface

public extension AppComponent {
    var songDetailPresenter: any SongDetailPresentable {
        shared {
            SongDetailPresenter()
        }
    }

    var homeFactory: any HomeFactory {
        HomeComponent(parent: self)
    }

    var musicDetailFactory: any MusicDetailFactory {
        MusicDetailComponent(parent: self)
    }

    var karaokeFactory: any KaraokeFactory {
        KaraokeComponent(parent: self)
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

    var fetchSongUseCase: any FetchSongUseCase {
        shared {
            FetchSongUseCaseImpl(
                songsRepository: songsRepository,
                likeRepository: likeRepository,
                authRepository: authRepository
            )
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

    var fetchNewSongsPlaylistUseCase: any FetchNewSongsPlaylistUseCase {
        shared {
            FetchNewSongsPlaylistUseCaseImpl(songsRepository: songsRepository)
        }
    }

    var fetchSongCreditsUseCase: any FetchSongCreditsUseCase {
        shared {
            FetchSongCreditsUseCaseImpl(songsRepository: songsRepository)
        }
    }
}
