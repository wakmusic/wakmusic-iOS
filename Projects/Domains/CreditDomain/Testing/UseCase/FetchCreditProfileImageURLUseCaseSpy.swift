import CreditDomainInterface
import RxSwift
import SongsDomainInterface

public final class FetchCreditProfileImageURLUseCaseSpy: FetchCreditProfileUseCase {
    public var callCount = 0
    public var handler: (String) -> Single<String> = { _ in fatalError() }

    public init() {}

    public func execute(
        name: String
    ) -> Single<String> {
        callCount += 1
        return handler(name)
    }
}
