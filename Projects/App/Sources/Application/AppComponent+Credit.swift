import CreditDomain
import CreditDomainInterface
import SongCreditFeature
import SongCreditFeatureInterface

public extension AppComponent {
    var remoteCreditDataSource: any RemoteCreditDataSource {
        shared {
            RemoteCreditDataSourceImpl(keychain: keychain)
        }
    }

    var creditRepository: any CreditRepository {
        shared {
            CreditRepositoryImpl(remoteCreditDataSource: remoteCreditDataSource)
        }
    }

    var fetchCreditSongListUseCase: any FetchCreditSongListUseCase {
        shared {
            FetchCreditSongListUseCaseImpl(creditRepository: creditRepository)
        }
    }

    var songCreditFactory: any SongCreditFactory {
        SongCreditComponent(parent: self)
    }
}
