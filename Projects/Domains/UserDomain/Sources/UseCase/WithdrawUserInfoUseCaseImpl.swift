import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct WithdrawUserInfoUseCaseImpl: WithdrawUserInfoUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Completable {
        userRepository.withdrawUserInfo()
    }
}
