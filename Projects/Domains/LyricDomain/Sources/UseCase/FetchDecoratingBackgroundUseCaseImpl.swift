import Foundation
import LyricDomainInterface
import RxSwift

public struct FetchDecoratingBackgroundUseCaseImpl: FetchDecoratingBackgroundUseCase {
    private let lyricRepository: any LyricRepository

    public init(
        lyricRepository: LyricRepository
    ) {
        self.lyricRepository = lyricRepository
    }

    public func execute() -> Single<[DecoratingBackgroundEntity]> {
        lyricRepository.fetchDecoratingBackground()
    }
}
