import AuthDomain
import AuthDomainInterface
import BaseFeature
import SignInFeature
import SignInFeatureInterface
import StorageFeature
import StorageFeatureInterface
import MyInfoFeature
import MyInfoFeatureInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var signInFactory: any SignInFactory {
        SignInComponent(parent: self)
    }

    var storageFactory: any StorageFactory {
        StorageComponent(parent: self)
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
