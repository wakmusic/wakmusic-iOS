import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct EditPlaylistOrderUseCaseImpl: EditPlaylistOrderUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(ids: [String]) -> Single<BaseEntity> {
        userRepository.editPlaylistOrder(ids: ids)
    }
}
