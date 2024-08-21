import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift
import SongsDomainInterface

public final class PlaylistRepositoryImpl: PlaylistRepository {
    private let remotePlaylistDataSource: any RemotePlaylistDataSource

    public init(
        remotePlaylistDataSource: RemotePlaylistDataSource
    ) {
        self.remotePlaylistDataSource = remotePlaylistDataSource
    }

    public func fetchRecommendPlaylist() -> Single<[RecommendPlaylistEntity]> {
        remotePlaylistDataSource.fetchRecommendPlaylist()
    }

    public func fetchPlaylistDetail(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity> {
        remotePlaylistDataSource.fetchPlaylistDetail(id: id, type: type)
    }

    public func fetchWMPlaylistDetail(id: String) -> Single<WMPlaylistDetailEntity> {
        remotePlaylistDataSource.fetchWMPlaylistDetail(id: id)
    }

    public func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable {
        remotePlaylistDataSource.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate)
    }

    public func createPlaylist(title: String) -> Single<PlaylistBaseEntity> {
        remotePlaylistDataSource.createPlaylist(title: title)
    }

    public func fetchPlaylistSongs(key: String) -> Single<[SongEntity]> {
        remotePlaylistDataSource.fetchPlaylistSongs(key: key)
    }

    public func updatePlaylist(key: String, songs: [String]) -> Completable {
        return remotePlaylistDataSource.updatePlaylist(key: key, songs: songs)
    }

    public func addSongIntoPlaylist(key: String, songs: [String]) -> Single<AddSongEntity> {
        remotePlaylistDataSource.addSongIntoPlaylist(key: key, songs: songs)
    }

    public func removeSongs(key: String, songs: [String]) -> Completable {
        remotePlaylistDataSource.removeSongs(key: key, songs: songs)
    }

    public func uploadDefaultImage(key: String, model: String) -> Completable {
        remotePlaylistDataSource.uploadDefaultImage(key: key, model: model)
    }

    public func subscribePlaylist(key: String, isSubscribing: Bool) -> Completable {
        remotePlaylistDataSource.subscribePlaylist(key: key, isSubscribing: isSubscribing)
    }

    public func checkSubscription(key: String) -> Single<Bool> {
        remotePlaylistDataSource.checkSubscription(key: key)
    }

    public func requestCustomImageURL(key: String, imageSize: Int) -> Single<CustomImageURLEntity> {
        remotePlaylistDataSource.requestCustomImageURL(key: key, imageSize: imageSize)
    }

    public func uploadCustomImage(presignedURL: String, data: Data) -> Completable {
        remotePlaylistDataSource.uploadCustomImage(presignedURL: presignedURL, data: data)
    }

    public func requestPlaylistOwnerID(key: String) -> Single<PlaylistOwnerIDEntity> {
        remotePlaylistDataSource.requestPlaylistOwnerID(key: key)
    }
}
