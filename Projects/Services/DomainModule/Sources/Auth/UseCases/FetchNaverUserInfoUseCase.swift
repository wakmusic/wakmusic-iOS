import DataMappingModule
import Foundation
import RxSwift

public protocol FetchNaverUserInfoUseCase {
    func execute(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity>
}
