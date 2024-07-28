import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UploadDefaultPlaylistImageUseCaseImpl: UploadDefaultPlaylistImageUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, model: String) -> Completable {
        playlistRepository.uploadDefaultImage(key: key, model: model)
    }
}
