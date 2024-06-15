import Foundation
import RxSwift

public protocol AuthRepository {
    func fetchToken(providerType: ProviderType, token: String) -> Single<AuthLoginEntity>
    func fetchNaverUserInfo(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity>
    func logout() -> Completable
    func checkIsExistAccessToken() -> Single<Bool>
}
