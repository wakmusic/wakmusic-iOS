import ImageDomain
import ImageDomainInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수 이름 같아야함

public extension AppComponent {
    var remoteImageDataSource: any RemoteImageDataSource {
        shared {
            RemoteImageDataSourceImpl(keychain: keychain)
        }
    }

    var imageRepository: any ImageRepository {
        shared {
            ImageRepositoryImpl(remoteImageDataSource: remoteImageDataSource)
        }
    }

    var fetchLyricDecoratingBackgroundUseCase: any FetchLyricDecoratingBackgroundUseCase {
        shared {
            FetchLyricDecoratingBackgroundUseCaseImpl(imageRepository: imageRepository)
        }
    }
}
