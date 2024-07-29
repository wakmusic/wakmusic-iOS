import Foundation
import RxSwift

public protocol FetchUserInfoUseCase {
    func execute() -> Single<UserInfoEntity>
}
