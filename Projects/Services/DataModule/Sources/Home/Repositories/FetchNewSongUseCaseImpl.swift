import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchNewSongUseCaseImpl: FetchNewSongUseCase {
    private let homeRepository: any HomeRepository

    public init(
        homeRepository: HomeRepository
    ) {
        self.homeRepository = homeRepository
    }
  
    public func execute(type: NewSongGroupType) -> Single<[NewSongEntity]> {
        homeRepository.fetchNewSong(type: type)
    }
}
