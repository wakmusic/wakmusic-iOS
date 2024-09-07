import FaqDomainInterface
import Foundation
import RxSwift

public struct FetchFaqUseCaseImpl: FetchFaqUseCase {
    private let faqRepository: any FaqRepository

    public init(
        faqRepository: FaqRepository
    ) {
        self.faqRepository = faqRepository
    }

    public func execute() -> Single<[FaqEntity]> {
        faqRepository.fetchQna()
    }
}
