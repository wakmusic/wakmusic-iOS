import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UploadPlaylistImageUseCaseImpl: UploadPlaylistImageUseCase {
    private let playListRepository: any PlayListRepository

    public init(
        playListRepository: PlayListRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, model: UploadImageType) -> Single<BaseImageEntity> {
        playListRepository.uploadImage(key: key, model: model)
    }
}
