import Foundation
import RxSwift

public protocol RemoteArtistDataSource {
    func fetchArtistList() -> Single<[ArtistEntity]>
    func fetchArtistDetail(id: String) -> Single<ArtistEntity>
    func fetchArtistSongList(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]>
    func fetchArtistSubscriptionStatus(id: String) -> Single<ArtistSubscriptionStatusEntity>
    func subscriptionArtist(id: String, on: Bool) -> Completable
}
