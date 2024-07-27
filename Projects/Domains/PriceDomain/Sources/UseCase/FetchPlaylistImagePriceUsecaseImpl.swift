import Foundation
import RxSwift
import PriceDomainInterface

public struct FetchPlaylistImagePriceUsecaseImpl: FetchPlaylistImagePriceUsecase {
    private let priceRepository: any PriceRepository

    public init(
        priceRepository: PriceRepository
    ) {
        self.priceRepository = priceRepository
    }

    public func execute() -> Single<PriceEntity> {
        priceRepository.fetchPlaylistImagePrice()
    }
}
