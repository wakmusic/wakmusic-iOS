import BaseFeature
@preconcurrency import NeedleFoundation
import SignInFeature
import StorageFeature
import UserDomain
import UserDomainInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var remoteUserDataSource: any RemoteUserDataSource {
        shared {
            RemoteUserDataSourceImpl(keychain: keychain)
        }
    }

    var userRepository: any UserRepository {
        shared {
            UserRepositoryImpl(remoteUserDataSource: remoteUserDataSource)
        }
    }

    var setProfileUseCase: any SetProfileUseCase {
        shared {
            SetProfileUseCaseImpl(userRepository: userRepository)
        }
    }

    var setUserNameUseCase: any SetUserNameUseCase {
        shared {
            SetUserNameUseCaseImpl(userRepository: userRepository)
        }
    }

    var fetchPlayListUseCase: any FetchPlaylistUseCase {
        shared {
            FetchPlaylistUseCaseImpl(userRepository: userRepository)
        }
    }

    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase {
        shared {
            FetchFavoriteSongsUseCaseImpl(userRepository: userRepository)
        }
    }

    var editFavoriteSongsOrderUseCase: any EditFavoriteSongsOrderUseCase {
        shared {
            EditFavoriteSongsOrderUseCaseImpl(userRepository: userRepository)
        }
    }

    var editPlayListOrderUseCase: any EditPlaylistOrderUseCase {
        shared {
            EditPlaylistOrderUseCaseImpl(userRepository: userRepository)
        }
    }

    var deletePlayListUseCase: any DeletePlaylistUseCase {
        shared {
            DeletePlaylistUseCaseImpl(userRepository: userRepository)
        }
    }

    var deleteFavoriteListUseCase: any DeleteFavoriteListUseCase {
        shared {
            DeleteFavoriteListUseCaseImpl(userRepository: userRepository)
        }
    }

    var fetchUserInfoUseCase: any FetchUserInfoUseCase {
        shared {
            FetchUserInfoUseCaseImpl(userRepository: userRepository)
        }
    }

    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase {
        shared {
            WithdrawUserInfoUseCaseImpl(userRepository: userRepository)
        }
    }

    var fetchFruitListUseCase: any FetchFruitListUseCase {
        shared {
            FetchFruitListUseCaseImpl(userRepository: userRepository)
        }
    }

    var fetchFruitDrawStatusUseCase: any FetchFruitDrawStatusUseCase {
        shared {
            FetchFruitDrawStatusUseCaseImpl(userRepository: userRepository)
        }
    }

    var drawFruitUseCase: any DrawFruitUseCase {
        shared {
            DrawFruitUseCaseImpl(userRepository: userRepository)
        }
    }
}
