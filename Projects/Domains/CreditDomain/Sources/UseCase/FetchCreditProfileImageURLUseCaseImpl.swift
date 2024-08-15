import CreditDomainInterface
import RxSwift

public final class FetchCreditProfileImageURLUseCaseImpl: FetchCreditProfileImageURLUseCase {
    private let creditRepository: any CreditRepository

    public init(
        creditRepository: any CreditRepository
    ) {
        self.creditRepository = creditRepository
    }

    public func execute(name: String) -> Single<String> {
        creditRepository.fetchCreditProfileImageURL(name: name)
    }
}
