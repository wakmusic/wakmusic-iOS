import Foundation
import PlaylistDomainInterface
import RxSwift

public struct FetchWMPlaylistDetailUseCaseImpl: FetchWMPlaylistDetailUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(id: String) -> Single<WMPlaylistDetailEntity> {
        playlistRepository.fetchWMPlaylistDetail(id: id)
    }
}
