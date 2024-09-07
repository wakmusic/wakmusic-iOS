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

    public func fetchProfileList() -> Single<[ProfileListEntity]> {
        remoteImageDataSource.fetchProfileList()
    }

    public func fetchDefaultPlaylistImage() -> Single<[DefaultImageEntity]> {
        remoteImageDataSource.fetchDefaultPlaylistImage()
    }
}
