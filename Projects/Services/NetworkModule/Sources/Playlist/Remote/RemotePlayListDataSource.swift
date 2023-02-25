import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemotePlayListDataSource {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchPlayListDetail(id:String,type:PlayListType) -> Single<PlayListDetailEntity>
    func createPlayList(title:String) -> Single<PlayListBaseEntity>
    func editPlayList(key:String,songs:[String]) -> Single<BaseEntity>
    func deletePlayList(key:String) -> Single<BaseEntity>
    func loadPlayList(key:String) -> Single<PlayListBaseEntity>
}
