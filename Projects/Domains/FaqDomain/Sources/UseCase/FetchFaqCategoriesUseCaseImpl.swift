import FaqDomainInterface
import Foundation
import RxSwift

public struct FetchFaqCategoriesUseCaseImpl: FetchFaqCategoriesUseCase {
    private let faqRepository: any FaqRepository

    public init(
        faqRepository: FaqRepository
    ) {
        self.faqRepository = faqRepository
    }

    public func execute() -> Single<FaqCategoryEntity> {
        faqRepository.fetchQnaCategories()
    }
}
