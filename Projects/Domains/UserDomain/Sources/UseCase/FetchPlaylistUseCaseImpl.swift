import Foundation
import RxSwift
import UserDomainInterface

public struct FetchPlaylistUseCaseImpl: FetchPlaylistUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Single<[PlaylistEntity]> {
        userRepository.fetchPlaylist()
    }
}
