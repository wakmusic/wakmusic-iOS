import BaseDomain
import BaseDomainInterface
import RxSwift
import SearchDomainInterface
import SongsDomain
import SongsDomainInterface

public final class RemoteSearchDataSourceImpl: BaseRemoteDataSource<SearchAPI>, RemoteSearchDataSource {
    public func fetchSearchSongs(
        order: SortType,
        filter: FilterType,
        text: String,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]> {
        return request(.fetchSongs(order: order, filter: filter, text: text, page: page, limit: limit))
            .map([SingleSongResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }

    public func fetchSearchPlaylist(
        order: SortType,
        text: String,
        page: Int,
        limit: Int
    ) -> Single<[SearchPlaylistEntity]> {
        return request(.fetchPlaylists(order: order, text: text, page: page, limit: limit))
            .map([SearchPlaylistDTO].self)
            .map { $0.map { $0.toDomain() }}
    }
}
