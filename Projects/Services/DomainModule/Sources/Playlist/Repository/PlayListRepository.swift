import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol PlayListRepository {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchPlayListDetail(id:String,type:PlayListType) -> Single<PlayListDetailEntity>
    func createPlayList(title:String) -> Single<PlayListBaseEntity>
    func editPlayList(key:String,songs:[String]) -> Single<BaseEntity>
    func editPlayListName(key:String,title:String) -> Single<BaseEntity>
    func deletePlayList(key:String) -> Single<BaseEntity>
    func loadPlayList(key:String) -> Single<PlayListBaseEntity>
}
