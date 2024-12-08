import Foundation
import RxSwift

public protocol RemoteFaqDataSource: Sendable {
    func fetchCategories() -> Single<FaqCategoryEntity>
    func fetchQna() -> Single<[FaqEntity]>
}
