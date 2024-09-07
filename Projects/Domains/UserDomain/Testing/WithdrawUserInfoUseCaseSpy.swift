import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct WithdrawUserInfoUseCaseSpy: WithdrawUserInfoUseCase {
    public func execute() -> Completable {
        return .empty()
    }
}
