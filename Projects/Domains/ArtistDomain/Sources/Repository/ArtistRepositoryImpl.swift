import ArtistDomainInterface
import RxSwift

public final class ArtistRepositoryImpl: ArtistRepository {
    private let remoteArtistDataSource: any RemoteArtistDataSource

    public init(
        remoteArtistDataSource: RemoteArtistDataSource
    ) {
        self.remoteArtistDataSource = remoteArtistDataSource
    }

    public func fetchArtistList() -> Single<[ArtistListEntity]> {
        remoteArtistDataSource.fetchArtistList()
    }

    public func fetchArtistSongList(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]> {
        remoteArtistDataSource.fetchArtistSongList(id: id, sort: sort, page: page)
    }

    public func fetchArtistSubscriptionStatus(id: String) -> Single<ArtistSubscriptionStatusEntity> {
        remoteArtistDataSource.fetchArtistSubscriptionStatus(id: id)
    }

    public func subscriptionArtist(id: String, on: Bool) -> Completable {
        remoteArtistDataSource.subscriptionArtist(id: id, on: on)
    }
}
