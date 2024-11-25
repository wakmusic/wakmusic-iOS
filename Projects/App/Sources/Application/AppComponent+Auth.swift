import AuthDomain
import AuthDomainInterface
import BaseFeature
import MyInfoFeature
import MyInfoFeatureInterface
@preconcurrency import NeedleFoundation
import SignInFeature
import SignInFeatureInterface
import StorageFeature
import StorageFeatureInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함

public extension AppComponent {
    var signInFactory: any SignInFactory {
        SignInComponent(parent: self)
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

    var regenerateAccessTokenUseCase: any ReGenerateAccessTokenUseCase {
        shared {
            ReGenerateAccessTokenUseCaseImpl(authRepository: authRepository)
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
