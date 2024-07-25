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

    public func execute(key: String, data: Data) -> Single<String> {
        let imageSize = data.count

        return playlistRepository.requestCustomImageURL(key: key, imageSize: imageSize)
            .flatMap { entity -> Single<String> in
                return playlistRepository.uploadCustomImage(presignedURL: entity.presignedURL, data: data)
            }
    }
}
