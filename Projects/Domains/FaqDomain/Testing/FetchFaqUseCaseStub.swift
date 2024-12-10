import FaqDomainInterface
import Foundation
import RxSwift

public struct FetchFaqUseCaseStub: FetchFaqUseCase, @unchecked Sendable {
    public func execute() -> Single<[FaqEntity]> {
        return .just([])
    }
}
