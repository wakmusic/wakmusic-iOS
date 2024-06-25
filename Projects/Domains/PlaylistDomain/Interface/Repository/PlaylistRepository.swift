import BaseDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface

public protocol PlaylistRepository {
    func fetchRecommendPlayList() -> Single<[RecommendPlaylistEntity]>
    func fetchPlayListDetail(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity>
    func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable
    func createPlayList(title: String) -> Single<PlaylistBaseEntity>
    func fetchPlaylistSongs(id: String) -> Single<[SongEntity]>
    func updatePlayList(key: String, songs: [String]) -> Completable
    func addSongIntoPlayList(key: String, songs: [String]) -> Single<AddSongEntity>
    func removeSongs(key: String, songs: [String]) -> Completable
    func uploadImage(key: String, model: UploadImageType) -> Single<BaseImageEntity>
}
