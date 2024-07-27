import Foundation
import RxSwift

public protocol FetchPlaylistImagePriceUsecase {
    func execute() -> Single<PriceEntity>
}
