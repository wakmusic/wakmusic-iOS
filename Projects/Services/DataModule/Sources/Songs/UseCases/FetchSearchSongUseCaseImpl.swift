import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchSearchSongUseCaseImpl: FetchSearchSongUseCase {
    
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }
    
    public func execute(type: SearchType, keyword: String) -> Single<[SongEntity]> {
        songsRepository.fetchSearchSong(type: type, keyword: keyword)
    }

  
}
