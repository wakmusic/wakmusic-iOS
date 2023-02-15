import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {
    public func fetchToken(id: String, type: ProviderType) -> Single<AuthLoginEntity> {
        request(.fetchToken(id: id, type: type))
            .map(AuthLoginResponseDTO.self)
            .map({$0.toDomain()})
    }
    
   
    
 
}
