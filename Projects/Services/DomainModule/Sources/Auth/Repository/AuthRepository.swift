import RxSwift
import DomainModule
import DataMappingModule
import ErrorModule
import Foundation

public protocol AuthRepository {
    func postLoginInfo(id:String,type:ProviderType) -> Single<[AuthLoginEntity]>

}
