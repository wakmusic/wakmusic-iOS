import Foundation
import ImageDomainInterface
import RxSwift

public struct FetchLyricDecoratingBackgroundUseCaseImpl: FetchLyricDecoratingBackgroundUseCase {
    private let imageRepository: any ImageRepository

    public init(
        imageRepository: ImageRepository
    ) {
        self.imageRepository = imageRepository
    }

    public func execute() -> Single<[LyricDecoratingBackgroundEntity]> {
        imageRepository.fetchLyricDecoratingBackground()
    }
}
