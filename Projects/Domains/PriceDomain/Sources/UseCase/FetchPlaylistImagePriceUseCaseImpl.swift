import Foundation
import PriceDomainInterface
import RxSwift

public struct FetchPlaylistImagePriceUseCaseImpl: FetchPlaylistImagePriceUseCase {
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
