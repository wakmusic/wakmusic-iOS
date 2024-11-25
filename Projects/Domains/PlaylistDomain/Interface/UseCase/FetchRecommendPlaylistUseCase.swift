import Foundation
import RxSwift

public protocol FetchRecommendPlaylistUseCase: Sendable {
    func execute() -> Single<[RecommendPlaylistEntity]>
}
