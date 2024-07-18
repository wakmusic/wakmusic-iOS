import TeamDomain
import TeamDomainInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수 이름 같아야함

public extension AppComponent {
    var remoteTeamDataSource: any RemoteTeamDataSource {
        shared {
            RemoteTeamDataSourceImpl(keychain: keychain)
        }
    }

    var teamRepository: any TeamRepository {
        shared {
            TeamRepositoryImpl(remoteTeamDataSource: remoteTeamDataSource)
        }
    }

    var fetchTeamListUseCase: any FetchTeamListUseCase {
        shared {
            FetchTeamListUseCaseImpl(teamRepository: teamRepository)
        }
    }
}
