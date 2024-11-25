import Foundation
import PriceDomain
import PriceDomainInterface
@preconcurrency import NeedleFoundation

extension AppComponent {
    var remotePriceDataSource: any RemotePriceDataSource {
        shared {
            RemotePriceDataSourceImpl(keychain: keychain)
        }
    }

    var priceRepository: any PriceRepository {
        shared {
            PriceRepositoryImpl(remotePriceDataSource: remotePriceDataSource)
        }
    }

    var fetchPlaylistCreationPriceUseCase: any FetchPlaylistCreationPriceUseCase {
        shared {
            FetchPlaylistCreationPriceUseCaseImpl(priceRepository: priceRepository)
        }
    }

    var fetchPlaylistImagePriceUseCase: any FetchPlaylistImagePriceUseCase {
        shared {
            FetchPlaylistImagePriceUseCaseImpl(priceRepository: priceRepository)
        }
    }
}
