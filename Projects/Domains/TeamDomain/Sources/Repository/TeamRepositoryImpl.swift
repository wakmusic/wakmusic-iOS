import Foundation
import RxSwift
import TeamDomainInterface

public final class TeamRepositoryImpl: TeamRepository {
    private let remoteTeamDataSource: any RemoteTeamDataSource

    public init(
        remoteTeamDataSource: RemoteTeamDataSource
    ) {
        self.remoteTeamDataSource = remoteTeamDataSource
    }

    public func fetchTeamList() -> Single<[TeamListEntity]> {
        remoteTeamDataSource.fetchTeamList()
    }
}
