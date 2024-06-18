import LyricDomain
import LyricDomainInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수 이름 같아야함

public extension AppComponent {
    var remoteLyricDataSource: any RemoteLyricDataSource {
        shared {
            RemoteLyricDataSourceImpl(keychain: keychain)
        }
    }

    var lyricRepository: any LyricRepository {
        shared {
            LyricRepositoryImpl(remoteLyricDataSource: remoteLyricDataSource)
        }
    }

    var fetchDecoratingBackgroundUseCase: any FetchDecoratingBackgroundUseCase {
        shared {
            FetchDecoratingBackgroundUseCaseImpl(lyricRepository: lyricRepository)
        }
    }
}
