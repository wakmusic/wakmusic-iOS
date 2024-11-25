import CreditDomainInterface
import RxSwift
import SongsDomainInterface

public final class FetchCreditProfileUseCaseSpy: FetchCreditProfileUseCase, @unchecked Sendable {
    public var callCount = 0
    public var handler: (String) -> Single<CreditProfileEntity> = { _ in fatalError() }

    public init() {}

    public func execute(
        name: String
    ) -> Single<CreditProfileEntity> {
        callCount += 1
        return handler(name)
    }
}
