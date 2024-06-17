import Foundation
import NoticeDomainInterface
import RxSwift

public struct FetchNoticeCategoriesUseCaseStub: FetchNoticeCategoriesUseCase {
    public func execute() -> Single<FetchNoticeCategoriesEntity> {
        return .just(FetchNoticeCategoriesEntity(categories: []))
    }
}
