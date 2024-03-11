//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import SignInFeature
import CommonFeature
import UserDomain
import StorageFeature
import UserDomainInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var profilePopComponent: ProfilePopComponent {
        ProfilePopComponent(parent: self)
    }

    var favoriteComponent: FavoriteComponent {
        FavoriteComponent(parent: self)
    }

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

    var fetchProfileListUseCase: any FetchProfileListUseCase {
        shared {
            FetchProfileListUseCaseImpl(userRepository: userRepository)
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

    var fetchPlayListUseCase: any FetchPlayListUseCase {
        shared {
            FetchPlayListUseCaseImpl(userRepository: userRepository)
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

    var editPlayListOrderUseCase: any EditPlayListOrderUseCase {
        shared {
            EditPlayListOrderUseCaseImpl(userRepository: userRepository)
        }
    }

    var deletePlayListUseCase: any DeletePlayListUseCase {
        shared {
            DeletePlayListUseCaseImpl(userRepository: userRepository)
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
}
