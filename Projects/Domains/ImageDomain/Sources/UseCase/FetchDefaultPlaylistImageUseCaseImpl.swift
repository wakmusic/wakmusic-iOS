import Foundation
import ImageDomainInterface
import RxSwift

public struct FetchDefaultPlaylistImageUseCaseImpl: FetchDefaultPlaylistImageUseCase {
    private let imageRepository: any ImageRepository

    public init(
        imageRepository: ImageRepository
    ) {
        self.imageRepository = imageRepository
    }

    public func execute() -> Single<[DefaultImageEntity]> {
        imageRepository.fetchDefaultPlaylistImage()
    }
}
