import BaseDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface
import PlaylistDomainInterface

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
