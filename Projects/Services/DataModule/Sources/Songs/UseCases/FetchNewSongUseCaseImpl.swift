import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchNewSongUseCaseImpl: FetchNewSongUseCase {
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }
  
    public func execute(type: NewSongGroupType) -> Single<[NewSongEntity]> {
        songsRepository.fetchNewSong(type: type)
    }
}
