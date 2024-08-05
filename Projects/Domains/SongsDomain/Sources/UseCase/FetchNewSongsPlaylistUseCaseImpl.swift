import RxSwift
import SongsDomainInterface

public struct FetchNewSongsPlaylistUseCaseImpl: FetchNewSongsPlaylistUseCase {
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }

    public func execute(type: NewSongGroupType) -> Single<NewSongsPlaylistEntity> {
        return songsRepository.fetchNewSongsPlaylist(type: type)
    }
}
