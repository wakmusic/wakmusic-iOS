import Foundation
import RxSwift

public protocol RemotePriceDataSource {
    func fetchPlaylistCreationPrice() -> Single<PriceEntity>
    func fetchPlaylistImagePrice() -> Single<PriceEntity>
}
