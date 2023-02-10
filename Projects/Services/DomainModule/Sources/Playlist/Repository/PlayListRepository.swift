import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol PlayListRepository {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
    func fetchRecommendPlayListDetail() -> Single<[RecommendPlayListDetailEntity]>
}
