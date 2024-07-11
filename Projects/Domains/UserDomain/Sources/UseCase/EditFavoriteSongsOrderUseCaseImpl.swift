import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct EditFavoriteSongsOrderUseCaseImpl: EditFavoriteSongsOrderUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(ids: [String]) -> Single<BaseEntity> {
        userRepository.editFavoriteSongsOrder(ids: ids)
    }
}
