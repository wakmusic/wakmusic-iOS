//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomain
import AuthDomainInterface
import BaseFeature
import SignInFeature
import StorageFeature

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var signInComponent: SignInComponent {
        SignInComponent(parent: self)
    }

    var storageComponent: StorageComponent {
        StorageComponent(parent: self)
    }

    var afterLoginComponent: AfterLoginComponent {
        AfterLoginComponent(parent: self)
    }

    var requestComponent: RequestComponent {
        RequestComponent(parent: self)
    }

    var localAuthDataSource: any LocalAuthDataSource {
        shared {
            LocalAuthDataSourceImpl(keychain: keychain)
        }
    }

    var remoteAuthDataSource: any RemoteAuthDataSource {
        shared {
            RemoteAuthDataSourceImpl(keychain: keychain)
        }
    }

    var authRepository: any AuthRepository {
        shared {
            AuthRepositoryImpl(
                localAuthDataSource: localAuthDataSource,
                remoteAuthDataSource: remoteAuthDataSource
            )
        }
    }

    var fetchTokenUseCase: any FetchTokenUseCase {
        shared {
            FetchTokenUseCaseImpl(authRepository: authRepository)
        }
    }

    var fetchNaverUserInfoUseCase: any FetchNaverUserInfoUseCase {
        shared {
            FetchNaverUserInfoUseCaseImpl(authRepository: authRepository)
        }
    }

    var logoutUseCase: any LogoutUseCase {
        shared {
            LogoutUseCaseImpl(authRepository: authRepository)
        }
    }

    var checkIsExistAccessTokenUseCase: any CheckIsExistAccessTokenUseCase {
        shared {
            CheckIsExistAccessTokenUseCaseImpl(authRepository: authRepository)
        }
    }
}
