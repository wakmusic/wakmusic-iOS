import Foundation
import RxSwift
import DataMappingModule

public protocol FetchRecommendPlaylistsUseCase {
    func execute() -> Single<[RecommendPlayListEntity]>
}
