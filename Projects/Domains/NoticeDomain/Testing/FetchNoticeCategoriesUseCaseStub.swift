import Foundation
import NoticeDomainInterface
import RxSwift

public struct FetchNoticeCategoriesUseCaseStub: FetchNoticeCategoriesUseCase, @unchecked Sendable {
    public func execute() -> Single<FetchNoticeCategoriesEntity> {
        return .just(FetchNoticeCategoriesEntity(categories: []))
    }
}
