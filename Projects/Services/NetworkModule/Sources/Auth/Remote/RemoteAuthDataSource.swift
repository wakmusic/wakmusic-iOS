import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public protocol RemoteAuthDataSource {
    func fetchToken(token: String, type: ProviderType) -> Single<AuthLoginEntity>
    func fetchNaverUserInfo(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity>
}
