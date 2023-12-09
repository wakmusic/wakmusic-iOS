import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteFaqDataSource {
    func fetchCategories() -> Single<FaqCategoryEntity>
    func fetchQna() -> Single<[FaqEntity]>
}
