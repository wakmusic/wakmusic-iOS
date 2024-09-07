import FaqDomainInterface
import Foundation
import RxSwift

public struct FetchFaqCategoriesUseCaseStub: FetchFaqCategoriesUseCase {
    public func execute() -> Single<FaqCategoryEntity> {
        return .just(FaqCategoryEntity(categories: []))
    }
}
