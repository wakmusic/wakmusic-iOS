import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift
import SongsDomainInterface

public struct FetchPlaylistSongsUseCaseImpl: FetchPlaylistSongsUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String) -> Single<[SongEntity]> {
        return playlistRepository.fetchPlaylistSongs(key: key)
    }
}
