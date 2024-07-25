import BaseDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface

public protocol PlaylistRepository {
    func fetchRecommendPlaylist() -> Single<[RecommendPlaylistEntity]>
    func fetchPlaylistDetail(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity>
    func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable
    func createPlaylist(title: String) -> Single<PlaylistBaseEntity>
    func fetchPlaylistSongs(id: String) -> Single<[SongEntity]>
    func updatePlaylist(key: String, songs: [String]) -> Completable
    func addSongIntoPlaylist(key: String, songs: [String]) -> Single<AddSongEntity>
    func removeSongs(key: String, songs: [String]) -> Completable
    func uploadDefaultImage(key: String, model: String) -> Completable
    func subscribePlaylist(key: String, isSubscribing: Bool) -> Completable
    func checkSubscription(key: String) -> Single<Bool>
    func fetchCustomImageUrl(key: String, imageSize: Int) -> Single<CustomImageUrlEntity>
}
