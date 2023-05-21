import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteQnaDataSourceImpl: BaseRemoteDataSource<QnaAPI>, RemoteQnaDataSource {
    public func fetchCategories() -> Single<[QnaCategoryEntity]> {
       return request(.fetchQnaCategories)
            .map([QnaCategoryResponseDTO].self)
            .map({$0.map({QnaCategoryEntity(category: $0.category)})})
    }
    
    public func fetchQna() -> Single<[QnaEntity]> {
        return request(.fetchQna)
            .map([QnaResponseDTO].self)
            .map({$0.map({$0.toDomain()})})
    }
}
