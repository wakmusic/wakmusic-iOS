import Foundation
import RxSwift

public protocol PriceRepository {
    func fetchPlaylistCreationPrice() -> Single<PriceEntity>
    func fetchPlaylistImagePrice() -> Single<PriceEntity>
}
