import Foundation
import PriceDomainInterface
import RxSwift

public final class PriceRepositoryImpl: PriceRepository {
    private let remotePriceDataSource: any RemotePriceDataSource

    public init(
        remotePriceDataSource: any RemotePriceDataSource
    ) {
        self.remotePriceDataSource = remotePriceDataSource
    }

    public func fetchPlaylistCreationPrice() -> Single<PriceEntity> {
        remotePriceDataSource.fetchPlaylistCreationPrice()
    }

    public func fetchPlaylistImagePrice() -> Single<PriceEntity> {
        remotePriceDataSource.fetchPlaylistImagePrice()
    }
}
