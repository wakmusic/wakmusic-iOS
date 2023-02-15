import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteAuthDataSource {
    func fetchToken(id:String,type:ProviderType) -> Single<AuthLoginEntity>
}
