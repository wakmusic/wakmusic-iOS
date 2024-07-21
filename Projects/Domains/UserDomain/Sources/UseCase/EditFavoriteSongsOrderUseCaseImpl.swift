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

    public func execute(ids: [String]) -> Completable {
        userRepository.editFavoriteSongsOrder(ids: ids)
    }
}
