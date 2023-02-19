import Foundation
import RxSwift
import DataMappingModule

public protocol FetchUserInfoUseCase {
    func execute() -> Single<AuthUserInfoEntity>
}
