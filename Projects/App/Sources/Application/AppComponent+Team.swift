import TeamDomain
import TeamDomainInterface
import TeamFeature
import TeamFeatureInterface
@preconcurrency import NeedleFoundation

public extension AppComponent {
    var teamInfoFactory: any TeamInfoFactory {
        TeamInfoComponent(parent: self)
    }

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
