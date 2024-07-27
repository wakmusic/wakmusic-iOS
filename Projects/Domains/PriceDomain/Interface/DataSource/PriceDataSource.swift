import Foundation
import RxSwift

public protocol PriceDataSource {
    func fetchPlaylistCreationPrice() ->  Single<PriceEntity>
    func fetchPlaylistImagePrice() ->  Single<PriceEntity>

}
