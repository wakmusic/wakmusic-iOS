import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct CheckSubscriptionUseCaseImpl: CheckSubscriptionUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String) -> Single<Bool> {
        playlistRepository.checkSubscription(key: key)
    }
}
