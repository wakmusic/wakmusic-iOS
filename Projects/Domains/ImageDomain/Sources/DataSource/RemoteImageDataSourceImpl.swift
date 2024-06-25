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
}
