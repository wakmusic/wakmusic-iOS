import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct SetUserNameUseCaseImpl: SetUserNameUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(name: String) -> Completable {
        userRepository.setUserName(name: name)
    }
}
