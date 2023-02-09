import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol RecommendPlayListRepository {
    func fetchRecommendPlayLists() -> Single<[RecommendPlayListEntity]>
}
