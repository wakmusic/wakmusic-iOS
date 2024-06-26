import BaseDomainInterface
import PlaylistDomainInterface
import RxSwift
import SongsDomainInterface

public final class PlaylistRepositoryImpl: PlaylistRepository {
    private let remotePlayListDataSource: any RemotePlayListDataSource

    public init(
        remotePlayListDataSource: RemotePlayListDataSource
    ) {
        self.remotePlayListDataSource = remotePlayListDataSource
    }

    public func fetchRecommendPlaylist() -> Single<[RecommendPlaylistEntity]> {
        remotePlayListDataSource.fetchRecommendPlaylist()
    }

    public func fetchPlaylistDetail(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity> {
        remotePlayListDataSource.fetchPlaylistDetail(id: id, type: type)
    }

    public func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable {
        remotePlayListDataSource.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate)
    }

    public func createPlaylist(title: String) -> Single<PlaylistBaseEntity> {
        remotePlayListDataSource.createPlaylist(title: title)
    }

    public func fetchPlaylistSongs(id: String) -> Single<[SongEntity]> {
        remotePlayListDataSource.fetchPlaylistSongs(id: id)
    }

    public func updatePlaylist(key: String, songs: [String]) -> Completable {
        return remotePlayListDataSource.updatePlaylist(key: key, songs: songs)
    }

    public func addSongIntoPlaylist(key: String, songs: [String]) -> Single<AddSongEntity> {
        remotePlayListDataSource.addSongIntoPlaylist(key: key, songs: songs)
    }

    public func removeSongs(key: String, songs: [String]) -> Completable {
        remotePlayListDataSource.removeSongs(key: key, songs: songs)
    }

    public func uploadImage(key: String, model: UploadImageType) -> Single<BaseImageEntity> {
        remotePlayListDataSource.uploadImage(key: key, model: model)
    }
}
