import CreditDomain
import CreditDomainInterface

public extension AppComponent {
    var fetchCreditSongListUseCase: any FetchCreditSongListUseCase {
        FetchCreditSongListUseCaseImpl()
    }
}
