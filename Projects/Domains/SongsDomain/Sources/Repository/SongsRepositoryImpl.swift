import RxSwift
import SongsDomainInterface

public final class SongsRepositoryImpl: SongsRepository {
    private let remoteSongsDataSource: any RemoteSongsDataSource

    public init(
        remoteSongsDataSource: RemoteSongsDataSource
    ) {
        self.remoteSongsDataSource = remoteSongsDataSource
    }

    public func fetchSearchSong(keyword: String) -> Single<SearchResultEntity> {
        remoteSongsDataSource.fetchSearchSong(keyword: keyword)
    }

    public func fetchLyrics(id: String) -> Single<[LyricsEntity]> {
        remoteSongsDataSource.fetchLyrics(id: id)
    }

    public func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]> {
        remoteSongsDataSource.fetchNewSongs(type: type, page: page, limit: limit)
    }
}
