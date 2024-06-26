import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UploadPlaylistImageUseCaseImpl: UploadPlaylistImageUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, model: UploadImageType) -> Single<BaseImageEntity> {
        playlistRepository.uploadImage(key: key, model: model)
    }
}
