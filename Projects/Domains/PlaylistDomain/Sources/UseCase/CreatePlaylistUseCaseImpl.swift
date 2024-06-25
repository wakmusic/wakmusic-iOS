import Foundation
import PlaylistDomainInterface
import RxSwift

public struct CreatePlaylistUseCaseImpl: CreatePlaylistUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(title: String) -> Single<PlaylistBaseEntity> {
        playlistRepository.createPlayList(title: title)
    }
}
