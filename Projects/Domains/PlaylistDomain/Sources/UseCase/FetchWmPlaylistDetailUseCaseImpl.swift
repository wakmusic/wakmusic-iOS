import Foundation
import PlaylistDomainInterface
import RxSwift

public struct FetchWmPlaylistDetailUseCaseImpl: FetchWmPlaylistDetailUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(id: String) -> Single<WmPlaylistDetailEntity> {
        playlistRepository.fetchWmPlaylistDetail(id: id)
    }
}
