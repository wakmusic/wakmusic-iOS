import Foundation
import RxSwift

public protocol FetchPlaylistImagePriceUseCase {
    func execute() -> Single<PriceEntity>
}
