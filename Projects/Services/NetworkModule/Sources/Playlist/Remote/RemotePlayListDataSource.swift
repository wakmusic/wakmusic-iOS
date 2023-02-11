import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemotePlayListDataSource {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchRecommendPlayListDetail(id:String) -> Single<[RecommendPlayListDetailEntity]>
}
