import Foundation
import RxSwift

public protocol FetchUserInfoUseCase: Sendable {
    func execute() -> Single<UserInfoEntity>
}
