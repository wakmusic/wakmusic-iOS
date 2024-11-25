import Foundation
import RxSwift

public protocol PriceRepository: Sendable {
    func fetchPlaylistCreationPrice() -> Single<PriceEntity>
    func fetchPlaylistImagePrice() -> Single<PriceEntity>
}
