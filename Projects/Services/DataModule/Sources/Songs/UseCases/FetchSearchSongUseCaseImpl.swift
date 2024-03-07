import DataMappingModule
import DomainModule
import ErrorModule
import RxSwift

public struct FetchSearchSongUseCaseImpl: FetchSearchSongUseCase {
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }

    public func execute(keyword: String) -> Single<SearchResultEntity> {
        songsRepository.fetchSearchSong(keyword: keyword)
    }
}
