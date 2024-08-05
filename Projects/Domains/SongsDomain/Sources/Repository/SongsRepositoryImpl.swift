import RxSwift
import SongsDomainInterface

public final class SongsRepositoryImpl: SongsRepository {
    private let remoteSongsDataSource: any RemoteSongsDataSource

    public init(
        remoteSongsDataSource: RemoteSongsDataSource
    ) {
        self.remoteSongsDataSource = remoteSongsDataSource
    }

    public func fetchSong(id: String) -> Single<SongEntity> {
        remoteSongsDataSource.fetchSong(id: id)
    }

    public func fetchLyrics(id: String) -> Single<LyricsEntity> {
        remoteSongsDataSource.fetchLyrics(id: id)
    }

    public func fetchSongCredits(id: String) -> Single<[SongCreditsEntity]> {
        remoteSongsDataSource.fetchSongCredits(id: id)
    }

    public func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]> {
        remoteSongsDataSource.fetchNewSongs(type: type, page: page, limit: limit)
    }

    public func fetchNewSongsPlaylist(type: NewSongGroupType) -> Single<NewSongsPlaylistEntity> {
        remoteSongsDataSource.fetchNewSongsPlaylist(type: type)
    }
}
