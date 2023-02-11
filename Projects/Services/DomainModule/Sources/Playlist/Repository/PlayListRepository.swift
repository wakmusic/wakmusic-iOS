import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol PlayListRepository {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchPlayListDetail(id:String,type:PlayListType) -> Single<PlayListDetailEntity>
}
