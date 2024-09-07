import RxSwift
import UserDomainInterface

public struct FetchFruitListUseCaseImpl: FetchFruitListUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Single<[FruitEntity]> {
        userRepository.fetchFruitList()
    }
}
