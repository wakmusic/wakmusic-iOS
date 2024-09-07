import BaseDomain
import Foundation
import ImageDomainInterface
import RxSwift

public final class RemoteImageDataSourceImpl: BaseRemoteDataSource<ImageAPI>, RemoteImageDataSource {
    public func fetchLyricDecoratingBackground() -> Single<[LyricDecoratingBackgroundEntity]> {
        request(.fetchLyricDecoratingBackground)
            .map([LyricDecoratingBackgroundResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchProfileList() -> Single<[ProfileListEntity]> {
        return request(.fetchProfileList)
            .map([FetchProfileListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchDefaultPlaylistImage() -> Single<[DefaultImageEntity]> {
        return request(.fetchDefaultPlaylistImage)
            .map([FetchDefaultImageResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }
}
