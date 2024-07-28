import Foundation
import RxSwift

public protocol FetchPlaylistCreationPriceUsecase {
    func execute() -> Single<PriceEntity>
}
