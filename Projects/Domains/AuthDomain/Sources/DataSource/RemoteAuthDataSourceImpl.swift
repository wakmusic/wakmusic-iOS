import AuthDomainInterface
import BaseDomain
import BaseDomainInterface
import Foundation
import RxSwift

public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {
    public func fetchToken(providerType: ProviderType, token: String) -> Single<AuthLoginEntity> {
        request(.fetchToken(providerType: providerType, token: token))
            .map(AuthLoginResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func reGenerateAccessToken() -> Single<AuthLoginEntity> {
        request(.reGenerateAccessToken)
            .map(AuthLoginResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func logout() -> Completable {
        request(.logout)
            .asCompletable()
    }
}
