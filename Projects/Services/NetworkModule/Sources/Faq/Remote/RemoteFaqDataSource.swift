import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public protocol RemoteFaqDataSource {
    func fetchCategories() -> Single<FaqCategoryEntity>
    func fetchQna() -> Single<[FaqEntity]>
}
