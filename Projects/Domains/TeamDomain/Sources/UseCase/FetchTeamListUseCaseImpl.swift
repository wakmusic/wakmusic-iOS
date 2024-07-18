import Foundation
import TeamDomainInterface
import RxSwift

public struct FetchTeamListUseCaseImpl: FetchTeamListUseCase {
    private let teamRepository: any TeamRepository

    public init(
        teamRepository: TeamRepository
    ) {
        self.teamRepository = teamRepository
    }

    public func execute() -> Single<[TeamListEntity]> {
        teamRepository.fetchTeamList()
    }
}
