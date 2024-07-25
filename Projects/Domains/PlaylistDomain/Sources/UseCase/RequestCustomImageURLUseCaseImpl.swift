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

    public func execute(key: String, imageSize: Int) -> Single<CustomImageURLEntity> {
        playlistRepository.requestCustomImageURL(key: key, imageSize: imageSize)
    }
}
