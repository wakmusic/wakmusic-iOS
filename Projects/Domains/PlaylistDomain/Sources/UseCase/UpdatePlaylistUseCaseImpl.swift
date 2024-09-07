import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UpdatePlaylistUseCaseImpl: UpdatePlaylistUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, songs: [String]) -> Completable {
        return playlistRepository.updatePlaylist(key: key, songs: songs)
    }
}
