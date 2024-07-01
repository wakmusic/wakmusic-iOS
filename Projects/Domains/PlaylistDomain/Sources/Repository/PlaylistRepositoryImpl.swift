import BaseDomainInterface
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

    public func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable {
        remotePlaylistDataSource.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate)
    }

    public func createPlaylist(title: String) -> Single<PlaylistBaseEntity> {
        remotePlaylistDataSource.createPlaylist(title: title)
    }

    public func fetchPlaylistSongs(id: String) -> Single<[SongEntity]> {
        remotePlaylistDataSource.fetchPlaylistSongs(id: id)
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

    public func uploadImage(key: String, model: UploadImageType) -> Single<BaseImageEntity> {
        remotePlaylistDataSource.uploadImage(key: key, model: model)
    }

    public func subscribePlaylist(key: String, isSubscribing: Bool) -> Completable {
        remotePlaylistDataSource.subscribePlaylist(key: key, isSubscribing: isSubscribing)
    }

    public func checkSubscriptionUseCase(key: String) -> Single<Bool> {
        remotePlaylistDataSource.checkSubscriptionUseCase(key: key)
    }
}
