import Foundation
import PriceDomain
import PriceDomainInterface

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

    var fetchPlaylistCreationPriceUsecase: any FetchPlaylistCreationPriceUsecase {
        shared {
            FetchPlaylistCreationPriceUsecaseImpl(priceRepository: priceRepository)
        }
    }

    var fetchPlaylistImagePriceUsecase: any FetchPlaylistImagePriceUsecase {
        shared {
            FetchPlaylistImagePriceUsecaseImpl(priceRepository: priceRepository)
        }
    }
}
