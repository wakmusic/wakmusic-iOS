import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct RequestCustomImageURLUseCaseImpl: RequestCustomImageURLUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, data: Data) -> Completable {
        let imageSize = data.count
        return playlistRepository.requestCustomImageURL(key: key, imageSize: imageSize)
            .flatMapCompletable { entity in
                return playlistRepository.uploadCustomImage(presignedURL: entity.presignedURL, data: data)
            }
    }
}
