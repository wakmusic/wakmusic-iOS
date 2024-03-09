import Foundation
import RxSwift

public protocol AuthRepository {
    func fetchToken(token: String, type: ProviderType) -> Single<AuthLoginEntity>
    func fetchNaverUserInfo(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity>
}
