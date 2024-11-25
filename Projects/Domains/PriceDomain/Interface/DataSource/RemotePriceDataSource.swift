import Foundation
import RxSwift

public protocol RemotePriceDataSource: Sendable {
    func fetchPlaylistCreationPrice() -> Single<PriceEntity>
    func fetchPlaylistImagePrice() -> Single<PriceEntity>
}
