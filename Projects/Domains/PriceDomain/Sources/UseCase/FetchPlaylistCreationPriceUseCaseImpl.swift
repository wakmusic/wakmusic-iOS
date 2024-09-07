import Foundation
import PriceDomainInterface
import RxSwift

public struct FetchPlaylistCreationPriceUseCaseImpl: FetchPlaylistCreationPriceUseCase {
    private let priceRepository: any PriceRepository

    public init(
        priceRepository: PriceRepository
    ) {
        self.priceRepository = priceRepository
    }

    public func execute() -> Single<PriceEntity> {
        priceRepository.fetchPlaylistCreationPrice()
    }
}
