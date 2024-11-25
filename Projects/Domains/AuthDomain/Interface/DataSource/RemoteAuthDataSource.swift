import Foundation
import RxSwift

public protocol RemoteAuthDataSource: Sendable {
    func fetchToken(providerType: ProviderType, token: String) -> Single<AuthLoginEntity>
    func reGenerateAccessToken() -> Single<AuthLoginEntity>
    func logout() -> Completable
}
