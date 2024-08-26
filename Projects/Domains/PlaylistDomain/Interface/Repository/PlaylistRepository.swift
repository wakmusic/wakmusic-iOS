import BaseDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface

public protocol PlaylistRepository {
    func fetchRecommendPlaylist() -> Single<[RecommendPlaylistEntity]>
    func fetchPlaylistDetail(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity>
    func fetchWMPlaylistDetail(id: String) -> Single<WMPlaylistDetailEntity>
    func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable
    func createPlaylist(title: String) -> Single<PlaylistBaseEntity>
    func fetchPlaylistSongs(key: String) -> Single<[SongEntity]>
    func updatePlaylist(key: String, songs: [String]) -> Completable
    func addSongIntoPlaylist(key: String, songs: [String]) -> Single<AddSongEntity>
    func removeSongs(key: String, songs: [String]) -> Completable
    func uploadDefaultImage(key: String, model: String) -> Completable
    func subscribePlaylist(key: String, isSubscribing: Bool) -> Completable
    func checkSubscription(key: String) -> Single<Bool>
    func requestCustomImageURL(key: String, imageSize: Int) -> Single<CustomImageURLEntity>
    func uploadCustomImage(presignedURL: String, data: Data) -> Completable
    func requestPlaylistOwnerID(key: String) -> Single<PlaylistOwnerIDEntity>
}
