import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct SetProfileUseCaseImpl: SetProfileUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(image: String) -> Completable {
        userRepository.setProfile(image: image)
    }
}
