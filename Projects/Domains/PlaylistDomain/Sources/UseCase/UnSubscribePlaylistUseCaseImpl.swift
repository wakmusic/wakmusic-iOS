import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UnSubscribePlaylistUseCaseImpl: UnSubscribePlaylistUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String) -> Completable {
        playlistRepository.unSubscribePlaylist(key: key)
    }
}
