import FaqDomainInterface
import Foundation
import RxSwift

public struct FetchFaqCategoriesUseCaseStub: FetchFaqCategoriesUseCase, @unchecked Sendable {
    public func execute() -> Single<FaqCategoryEntity> {
        return .just(FaqCategoryEntity(categories: []))
    }
}
