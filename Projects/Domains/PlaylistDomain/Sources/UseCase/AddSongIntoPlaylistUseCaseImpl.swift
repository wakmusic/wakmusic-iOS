import Foundation
import PlaylistDomainInterface
import RxSwift

public struct AddSongIntoPlaylistUseCaseImpl: AddSongIntoPlaylistUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, songs: [String]) -> Single<AddSongEntity> {
        playlistRepository.addSongIntoPlaylist(key: key, songs: songs)
    }
}
