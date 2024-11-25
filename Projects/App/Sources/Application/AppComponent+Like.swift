import BaseFeature
import LikeDomain
import LikeDomainInterface
import SignInFeature
import StorageFeature
@preconcurrency import NeedleFoundation

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var remoteLikeDataSource: any RemoteLikeDataSource {
        shared {
            RemoteLikeDataSourceImpl(keychain: keychain)
        }
    }

    var likeRepository: any LikeRepository {
        shared {
            LikeRepositoryImpl(remoteLikeDataSource: remoteLikeDataSource)
        }
    }

    var addLikeSongUseCase: any AddLikeSongUseCase {
        shared {
            AddLikeSongUseCaseImpl(likeRepository: likeRepository)
        }
    }

    var cancelLikeSongUseCase: any CancelLikeSongUseCase {
        shared {
            CancelLikeSongUseCaseImpl(likeRepository: likeRepository)
        }
    }
}
