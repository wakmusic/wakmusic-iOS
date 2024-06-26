import Foundation
import RxSwift

public protocol FetchRecommendPlaylistUseCase {
    func execute() -> Single<[RecommendPlaylistEntity]>
}
