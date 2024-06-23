import Foundation
import ImageDomainInterface
import RxSwift

public final class ImageRepositoryImpl: ImageRepository {
    private let remoteImageDataSource: any RemoteImageDataSource

    public init(
        remoteImageDataSource: RemoteImageDataSource
    ) {
        self.remoteImageDataSource = remoteImageDataSource
    }

    public func fetchLyricDecoratingBackground() -> Single<[LyricDecoratingBackgroundEntity]> {
        remoteImageDataSource.fetchLyricDecoratingBackground()
    }
}
