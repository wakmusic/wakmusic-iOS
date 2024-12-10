import Foundation
import RxSwift

public protocol FetchPlaylistCreationPriceUseCase: Sendable {
    func execute() -> Single<PriceEntity>
}
