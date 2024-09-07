import RxSwift
import SongsDomainInterface

public struct FetchNewSongsUseCaseImpl: FetchNewSongsUseCase {
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }

    public func execute(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]> {
        return songsRepository.fetchNewSongs(type: type, page: page, limit: limit)
    }
}
