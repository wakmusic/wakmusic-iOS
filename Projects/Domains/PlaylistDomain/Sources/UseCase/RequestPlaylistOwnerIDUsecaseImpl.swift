import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct RequestPlaylistOwnerIDUsecaseImpl: RequestPlaylistOwnerIDUsecase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String) -> Single<PlaylistOwnerIDEntity> {
        playlistRepository.requestPlaylistOwnerID(key: key)
    }
}
