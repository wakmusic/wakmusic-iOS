import DataMappingModule
import ErrorModule
import Foundation
import RxSwift

public protocol PlayListRepository {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchPlayListDetail(id: String, type: PlayListType) -> Single<PlayListDetailEntity>
    func createPlayList(title: String) -> Single<PlayListBaseEntity>
    func editPlayList(key: String, songs: [String]) -> Single<BaseEntity>
    func editPlayListName(key: String, title: String) -> Single<EditPlayListNameEntity>
    func deletePlayList(key: String) -> Single<BaseEntity>
    func loadPlayList(key: String) -> Single<PlayListBaseEntity>
    func addSongIntoPlayList(key: String, songs: [String]) -> Single<AddSongEntity>
    func removeSongs(key: String, songs: [String]) -> Single<BaseEntity>
}
