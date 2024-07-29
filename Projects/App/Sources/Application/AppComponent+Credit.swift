import CreditDomain
import CreditDomainInterface
import SongCreditFeature
import SongCreditFeatureInterface

public extension AppComponent {
    var fetchCreditSongListUseCase: any FetchCreditSongListUseCase {
        FetchCreditSongListUseCaseImpl()
    }

    var songCreditFactory: any SongCreditFactory {
        SongCreditComponent(parent: self)
    }
}
