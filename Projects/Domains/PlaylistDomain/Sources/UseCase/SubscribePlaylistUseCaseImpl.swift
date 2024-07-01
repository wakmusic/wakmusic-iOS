import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct SubscribePlaylistUseCaseImpl: SubscribePlaylistUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, isSubscribing: Bool) -> Completable {
        playlistRepository.subscribePlaylist(key: key, isSubscribing: isSubscribing)
    }
}
