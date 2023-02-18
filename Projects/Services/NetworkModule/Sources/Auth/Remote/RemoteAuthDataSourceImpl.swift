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
    
    public func fetchNaverUserInfo(tokenType: String, accessToken: String) -> RxSwift.Single<DomainModule.NaverUserInfoEntity> {
        request(.fetchNaverUserInfo(tokenType: tokenType, accessToken: accessToken))
            .map(NaverUserInfoResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func fetchUserInfo(token: String) -> Single<AuthUserInfoEntity> {
        request(.fetUserInfo(token: token))
            .map(AuthUserInfoResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func withdrawUserInfo(token: String) -> Single<BaseEntity> {
        request(.withdrawUserInfo(token: token))
            .map(BaseResponseDTO.self)
            .map{ $0.toDomain() }
    }
}
