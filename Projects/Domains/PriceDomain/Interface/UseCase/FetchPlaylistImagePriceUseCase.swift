import Foundation
import RxSwift

public protocol FetchPlaylistImagePriceUseCase: Sendable {
    func execute() -> Single<PriceEntity>
}
