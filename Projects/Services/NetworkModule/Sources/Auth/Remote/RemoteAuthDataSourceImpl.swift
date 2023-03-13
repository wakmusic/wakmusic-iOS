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
    
    public func fetchUserInfo() -> Single<AuthUserInfoEntity> {
        request(.fetUserInfo)
            .map(AuthUserInfoResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func withdrawUserInfo() -> Single<BaseEntity> {
        request(.withdrawUserInfo)
            .map(BaseResponseDTO.self)
            .map{ $0.toDomain() }
    }
}
