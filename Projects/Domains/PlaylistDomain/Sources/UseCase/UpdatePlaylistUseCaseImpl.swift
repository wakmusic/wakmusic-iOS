import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UpdatePlaylistUseCaseImpl: UpdatePlaylistUseCase {
    private let playListRepository: any PlaylistRepository

    public init(
        playListRepository: PlaylistRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, songs: [String]) -> Completable {
        return playListRepository.updatePlaylist(key: key, songs: songs)
    }
}
