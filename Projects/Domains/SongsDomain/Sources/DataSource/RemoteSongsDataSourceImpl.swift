import BaseDomain
import SongsDomainInterface
import Foundation
import RxSwift

public final class RemoteSongsDataSourceImpl: BaseRemoteDataSource<SongsAPI>, RemoteSongsDataSource {
    public func fetchSearchSong(keyword: String) -> Single<SearchResultEntity> {
        request(.fetchSearchSong(keyword: keyword))
            .map(SearchResultResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchLyrics(id: String) -> Single<[LyricsEntity]> {
        request(.fetchLyrics(id: id))
            .map([LyricsResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }

    public func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]> {
        request(.fetchNewSongs(type: type, page: page, limit: limit))
            .map([NewSongsResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }
}
