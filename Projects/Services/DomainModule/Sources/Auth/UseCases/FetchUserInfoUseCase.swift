import Foundation
import RxSwift
import DataMappingModule

public protocol FetchUserInfoUseCase {
    func execute(token:String) -> Single<AuthUserInfoEntity>
}
