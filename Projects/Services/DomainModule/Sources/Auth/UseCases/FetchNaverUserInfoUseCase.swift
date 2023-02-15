import Foundation
import RxSwift
import DataMappingModule

public protocol FetchNaverUserInfoUseCase {
    func execute(tokenType:String,accessToken:String) -> Single<NaverUserInfoEntity>
}
