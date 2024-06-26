import Foundation
import PlaylistDomainInterface
import RxSwift

public struct AddSongIntoPlaylistUseCaseImpl: AddSongIntoPlaylistUseCase {
    private let playListRepository: any PlaylistRepository

    public init(
        playListRepository: PlaylistRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, songs: [String]) -> Single<AddSongEntity> {
        playListRepository.addSongIntoPlaylist(key: key, songs: songs)
    }
}
