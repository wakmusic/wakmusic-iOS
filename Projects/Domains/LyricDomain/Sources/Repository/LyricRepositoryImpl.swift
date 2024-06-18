import Foundation
import LyricDomainInterface
import RxSwift

public final class LyricRepositoryImpl: LyricRepository {
    private let remoteLyricDataSource: any RemoteLyricDataSource

    public init(
        remoteLyricDataSource: RemoteLyricDataSource
    ) {
        self.remoteLyricDataSource = remoteLyricDataSource
    }

    public func fetchDecoratingBackground() -> Single<[DecoratingBackgroundEntity]> {
        remoteLyricDataSource.fetchDecoratingBackground()
    }
}
