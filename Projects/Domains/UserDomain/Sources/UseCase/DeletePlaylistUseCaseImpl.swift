import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct DeletePlaylistUseCaseImpl: DeletePlaylistUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(ids: [String]) -> Completable {
        userRepository.deletePlaylist(ids: ids)
    }
}
