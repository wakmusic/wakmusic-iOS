import RxSwift
import SearchDomainInterface
import SongsDomainInterface

public final class SearchRepositoryImpl: SearchRepository {
    private let remoteSearchDataSource: any RemoteSearchDataSource

    public init(remoteSearchDataSource: any RemoteSearchDataSource) {
        self.remoteSearchDataSource = remoteSearchDataSource
    }

    public func fetchSearchSongs(
        order: SortType,
        filter: FilterType,
        text: String,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]> {
        return remoteSearchDataSource.fetchSearchSongs(
            order: order,
            filter: filter,
            text: text,
            page: page,
            limit: limit
        )
    }

    public func fetchSearchPlaylist(
        order: SortType,
        text: String,
        page: Int,
        limit: Int
    ) -> Single<[SearchPlaylistEntity]> {
        return remoteSearchDataSource.fetchSearchPlaylist(order: order, text: text, page: page, limit: limit)
    }
}
