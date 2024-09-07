import Foundation
import RxSwift

public protocol FetchPlaylistCreationPriceUseCase {
    func execute() -> Single<PriceEntity>
}
