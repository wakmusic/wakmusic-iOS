import AuthDomainInterface
import BaseDomain
import Foundation
import RxSwift

public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {
    public func fetchToken(token: String, type: ProviderType) -> Single<AuthLoginEntity> {
        request(.fetchToken(token: token, type: type))
            .map(AuthLoginResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchNaverUserInfo(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity> {
        request(.fetchNaverUserInfo(tokenType: tokenType, accessToken: accessToken))
            .map(NaverUserInfoResponseDTO.self)
            .map { $0.toDomain() }
    }
}
