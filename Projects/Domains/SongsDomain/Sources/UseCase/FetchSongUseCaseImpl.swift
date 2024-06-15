import RxSwift
import SongsDomainInterface

public struct FetchSongUseCaseImpl: FetchSongUseCase {
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }

    public func execute(id: String) -> Single<SongEntity> {
        songsRepository.fetchSong(id: id)
    }
}
