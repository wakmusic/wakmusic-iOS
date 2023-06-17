import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {
    public func fetchToken(token: String, type: ProviderType) -> Single<AuthLoginEntity> {
        request(.fetchToken(token: token, type: type))
            .map(AuthLoginResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func fetchNaverUserInfo(tokenType: String, accessToken: String) -> RxSwift.Single<DomainModule.NaverUserInfoEntity> {
        request(.fetchNaverUserInfo(tokenType: tokenType, accessToken: accessToken))
            .map(NaverUserInfoResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func fetchUserInfo() -> Single<AuthUserInfoEntity> {
        request(.fetchUserInfo)
            .map(AuthUserInfoResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func withdrawUserInfo() -> Single<BaseEntity> {
        request(.withdrawUserInfo)
            .map(BaseResponseDTO.self)
            .map{ $0.toDomain() }
    }
}
