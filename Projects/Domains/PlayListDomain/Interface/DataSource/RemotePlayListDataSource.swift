import BaseDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface

public protocol RemotePlayListDataSource {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchPlayListDetail(id: String, type: PlayListType) -> Single<PlayListDetailEntity>
    func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable
    func createPlayList(title: String) -> Single<PlayListBaseEntity>
    func fetchPlaylistSongs(id: String) -> Single<[SongEntity]>
    func updatePlaylist(key: String, songs: [String]) -> Single<BaseEntity>
    func addSongIntoPlayList(key: String, songs: [String]) -> Single<AddSongEntity>
    func removeSongs(key: String, songs: [String]) -> Single<BaseEntity>
}
