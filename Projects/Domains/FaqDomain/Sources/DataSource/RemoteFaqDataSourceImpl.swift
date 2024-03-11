import BaseDomain
import FaqDomainInterface
import Foundation
import RxSwift

public final class RemoteFaqDataSourceImpl: BaseRemoteDataSource<FaqAPI>, RemoteFaqDataSource {
    public func fetchCategories() -> Single<FaqCategoryEntity> {
        return request(.fetchFaqCategories)
            .map(FaqCategoryResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchQna() -> Single<[FaqEntity]> {
        return request(.fetchFaq)
            .map([FaqResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }
}
