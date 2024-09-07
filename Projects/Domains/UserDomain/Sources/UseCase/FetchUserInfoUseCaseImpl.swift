import Foundation
import RxSwift
import UserDomainInterface

public struct FetchUserInfoUseCaseImpl: FetchUserInfoUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Single<UserInfoEntity> {
        userRepository.fetchUserInfo()
    }
}
