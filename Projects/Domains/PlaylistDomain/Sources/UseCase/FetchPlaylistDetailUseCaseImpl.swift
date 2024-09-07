import Foundation
import PlaylistDomainInterface
import RxSwift

public struct FetchPlaylistDetailUseCaseImpl: FetchPlaylistDetailUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity> {
        playlistRepository.fetchPlaylistDetail(id: id, type: type)
    }
}
