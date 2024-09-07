import RxSwift
import UserDomainInterface

public struct DrawFruitUseCaseImpl: DrawFruitUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Single<FruitEntity> {
        userRepository.drawFruit()
    }
}
