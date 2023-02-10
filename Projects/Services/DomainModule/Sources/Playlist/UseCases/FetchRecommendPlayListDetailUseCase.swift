import Foundation
import RxSwift
import DataMappingModule

public protocol FetchRecommendPlayListDetailUseCase {
    func execute() -> Single<[RecommendPlayListDetailEntity]>
}
