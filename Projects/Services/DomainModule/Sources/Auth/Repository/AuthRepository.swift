import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol AuthRepository {
    func fetchToken(id:String,type:ProviderType) -> Single<AuthLoginEntity>
    func fetchNaverUserInfo(tokenType:String,accessToken:String) -> Single<NaverUserInfoEntity>
    func fetchUserInfo(token:String) -> Single<AuthUserInfoEntity>
    func withdrawUserInfo(token:String) -> Completable

}
