import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol PlayListDataSource {
    func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]>
}
