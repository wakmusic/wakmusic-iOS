import RxSwift
import UserDomainInterface

public struct FetchFruitDrawStatusUseCaseImpl: FetchFruitDrawStatusUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Single<FruitDrawStatusEntity> {
        userRepository.fetchFruitDrawStatus()
    }
}
