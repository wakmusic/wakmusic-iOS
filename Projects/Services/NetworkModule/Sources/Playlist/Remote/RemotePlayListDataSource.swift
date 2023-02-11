import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemotePlayListDataSource {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchPlayListDetail(id:String,type:PlayListType) -> Single<PlayListDetailEntity>
}
