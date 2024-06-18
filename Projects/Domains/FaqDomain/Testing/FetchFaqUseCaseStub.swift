import FaqDomainInterface
import Foundation
import RxSwift

public struct FetchFaqUseCaseStub: FetchFaqUseCase {
    public func execute() -> Single<[FaqEntity]> {
        return .just([])
    }
}
