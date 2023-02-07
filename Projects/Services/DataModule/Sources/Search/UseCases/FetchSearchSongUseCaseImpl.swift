import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchSearchSongUseCaseImpl: FetchSearchSongUseCase {
    
    private let searchRepository: any SearchRepository

    public init(
        searchRepository: SearchRepository
    ) {
        self.searchRepository = searchRepository
    }
    
    public func execute(type: SearchType, keyword: String) -> Single<[SearchEntity]> {
        searchRepository.fetchSearchSong(type: type, keyword: keyword)
    }

  
}
