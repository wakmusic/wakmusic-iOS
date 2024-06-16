import Foundation
import RxSwift

public protocol AuthRepository {
    func fetchToken(providerType: ProviderType, token: String) -> Single<AuthLoginEntity>
    func reGenerateAccessToken() -> Single<AuthLoginEntity>
    func logout() -> Completable
    func checkIsExistAccessToken() -> Single<Bool>
}
