import BaseDomainInterface
import PlaylistDomainInterface
import RxSwift
import SongsDomainInterface

public final class PlayListRepositoryImpl: PlaylistRepository {
    private let remotePlayListDataSource: any RemotePlaylistDataSource

    public init(
        remotePlayListDataSource: RemotePlaylistDataSource
    ) {
        self.remotePlayListDataSource = remotePlayListDataSource
    }

    public func fetchRecommendPlayList() -> Single<[RecommendPlaylistEntity]> {
        remotePlayListDataSource.fetchRecommendPlayList()
    }

    public func fetchPlayListDetail(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity> {
        remotePlayListDataSource.fetchPlayListDetail(id: id, type: type)
    }

    public func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable {
        remotePlayListDataSource.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate)
    }

    public func createPlayList(title: String) -> Single<PlaylistBaseEntity> {
        remotePlayListDataSource.createPlayList(title: title)
    }

    public func fetchPlaylistSongs(id: String) -> Single<[SongEntity]> {
        remotePlayListDataSource.fetchPlaylistSongs(id: id)
    }

    public func updatePlayList(key: String, songs: [String]) -> Completable {
        return remotePlayListDataSource.updatePlaylist(key: key, songs: songs)
    }

    public func addSongIntoPlayList(key: String, songs: [String]) -> Single<AddSongEntity> {
        remotePlayListDataSource.addSongIntoPlayList(key: key, songs: songs)
    }

    public func removeSongs(key: String, songs: [String]) -> Completable {
        remotePlayListDataSource.removeSongs(key: key, songs: songs)
    }

    public func uploadImage(key: String, model: UploadImageType) -> Single<BaseImageEntity> {
        remotePlayListDataSource.uploadImage(key: key, model: model)
    }
}
