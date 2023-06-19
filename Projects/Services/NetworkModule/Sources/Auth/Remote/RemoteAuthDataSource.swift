import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteAuthDataSource {
    func fetchToken(token:String,type:ProviderType) -> Single<AuthLoginEntity>
    func fetchNaverUserInfo(tokenType:String,accessToken:String) -> Single<NaverUserInfoEntity>
    func fetchUserInfo() -> Single<AuthUserInfoEntity>
    func withdrawUserInfo() -> Single<BaseEntity>
}
