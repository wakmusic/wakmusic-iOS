import Foundation
import RxSwift
import DataMappingModule

public protocol FetchRecommendPlayListDetailUseCase {
    func execute(id:String) -> Single<[RecommendPlayListDetailEntity]>
}
