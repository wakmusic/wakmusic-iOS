import AppDomain
import AppDomainInterface
@preconcurrency import NeedleFoundation

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수 이름 같아야함

public extension AppComponent {
    var remoteAppDataSource: any RemoteAppDataSource {
        shared {
            RemoteAppDataSourceImpl(keychain: keychain)
        }
    }

    var appRepository: any AppRepository {
        shared {
            AppRepositoryImpl(remoteAppDataSource: remoteAppDataSource)
        }
    }

    var fetchAppCheckUseCase: any FetchAppCheckUseCase {
        shared {
            FetchAppCheckUseCaseImpl(appRepository: appRepository)
        }
    }
}
