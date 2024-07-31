import BaseFeature
import LikeDomain
import LikeDomainInterface
import SignInFeature
import StorageFeature

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var remoteLikeDataSource: any RemoteLikeDataSource {
        shared {
            RemoteLikeDataSourceImpl(keychain: keychain)
        }
    }

    var localLikeDataSource: any LocalLikeDataSource {
        shared {
            LocalLikeDataSourceImpl()
        }
    }

    var likeRepository: any LikeRepository {
        shared {
            LikeRepositoryImpl(
                remoteLikeDataSource: remoteLikeDataSource,
                localLikeDataSource: localLikeDataSource
            )
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

    var checkIsLikedSongUseCase: any CheckIsLikedSongUseCase {
        shared {
            CheckIsLikedSongUseCaseImpl(likeRepository: likeRepository)
        }
    }
}
