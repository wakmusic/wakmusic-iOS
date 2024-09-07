import CreditDomainInterface
import RxSwift

public final class FetchCreditProfileUseCaseImpl: FetchCreditProfileUseCase {
    private let creditRepository: any CreditRepository

    public init(
        creditRepository: any CreditRepository
    ) {
        self.creditRepository = creditRepository
    }

    public func execute(name: String) -> Single<CreditProfileEntity> {
        creditRepository.fetchCreditProfile(name: name)
    }
}
