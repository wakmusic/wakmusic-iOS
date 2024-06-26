import Foundation
import RxSwift

public protocol FetchRecommendPlayListUseCase {
    func execute() -> Single<[RecommendPlaylistEntity]>
}
