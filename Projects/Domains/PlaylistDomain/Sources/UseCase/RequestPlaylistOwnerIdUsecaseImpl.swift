import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct RequestPlaylistOwnerIdUsecaseImpl: RequestPlaylistOwnerIdUsecase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String) -> Single<PlaylistOwnerIdEntity> {
        playlistRepository.requestPlaylistOwnerId(key: key)
    }
}
