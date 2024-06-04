import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct WithdrawUserInfoUseCaseSpy: WithdrawUserInfoUseCase {
    public func execute() -> Single<BaseEntity> {
        return .just(.init(status: 200))
    }
}
