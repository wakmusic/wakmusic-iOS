import Foundation
import RxSwift
import DataMappingModule

public protocol FetchRecommendPlayListUseCase {
    func execute() -> Single<[RecommendPlayListEntity]>
}
