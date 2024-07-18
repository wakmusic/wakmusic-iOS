import BaseDomain
import Foundation
import RxSwift
import TeamDomainInterface

public final class RemoteTeamDataSourceImpl: BaseRemoteDataSource<TeamAPI>, RemoteTeamDataSource {
    public func fetchTeamList() -> Single<[TeamListEntity]> {
        request(.fetchTeamList)
            .map([FetchTeamListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }
}
