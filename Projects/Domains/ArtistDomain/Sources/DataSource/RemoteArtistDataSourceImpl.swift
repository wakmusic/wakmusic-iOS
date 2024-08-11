import ArtistDomainInterface
import BaseDomain
import Foundation
import RxSwift

public final class RemoteArtistDataSourceImpl: BaseRemoteDataSource<ArtistAPI>, RemoteArtistDataSource {
    public func fetchArtistList() -> Single<[ArtistEntity]> {
        request(.fetchArtistList)
            .map([ArtistListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchArtistDetail(id: String) -> Single<ArtistEntity> {
        request(.fetchArtistDetail(id: id))
            .map(ArtistDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchArtistSongList(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]> {
        request(.fetchArtistSongList(id: id, sort: sort, page: page))
            .map([ArtistSongListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchArtistSubscriptionStatus(id: String) -> Single<ArtistSubscriptionStatusEntity> {
        request(.fetchSubscriptionStatus(id: id))
            .map(ArtistSubscriptionStatusResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func subscriptionArtist(id: String, on: Bool) -> Completable {
        request(.subscriptionArtist(id: id, on: on))
            .asCompletable()
    }
}
