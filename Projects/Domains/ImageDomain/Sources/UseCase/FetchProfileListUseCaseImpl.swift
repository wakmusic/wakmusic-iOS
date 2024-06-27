import Foundation
import ImageDomainInterface
import RxSwift

public struct FetchProfileListUseCaseImpl: FetchProfileListUseCase {
    private let imageRepository: any ImageRepository

    public init(
        imageRepository: ImageRepository
    ) {
        self.imageRepository = imageRepository
    }

    public func execute() -> Single<[ProfileListEntity]> {
        imageRepository.fetchProfileList()
    }
}
