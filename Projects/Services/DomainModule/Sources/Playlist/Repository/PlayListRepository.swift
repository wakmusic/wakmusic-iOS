import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol PlayListRepository {
    func fetchRecommendPlayLists() -> Single<[RecommendPlayListEntity]>
}
