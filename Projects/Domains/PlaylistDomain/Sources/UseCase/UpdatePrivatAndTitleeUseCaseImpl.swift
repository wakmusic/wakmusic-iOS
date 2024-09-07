import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UpdateTitleAndPrivateUseCaseImpl: UpdateTitleAndPrivateUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, title: String?, isPrivate: Bool?) -> Completable {
        playlistRepository.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate)
    }
}
