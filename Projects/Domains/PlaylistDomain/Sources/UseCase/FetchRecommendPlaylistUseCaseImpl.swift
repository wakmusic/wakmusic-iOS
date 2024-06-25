import Foundation
import PlaylistDomainInterface
import RxSwift

public struct FetchRecommendPlaylistUseCaseImpl: FetchRecommendPlaylistUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute() -> Single<[RecommendPlaylistEntity]> {
        playlistRepository.fetchRecommendPlayList()
    }
}
