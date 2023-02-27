import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteQnaDataSource {
    func fetchCategories() -> Single<[QnaCategoryEntity]>
    func fetchQna() -> Single<[QnaEntity]>
}
