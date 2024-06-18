import Foundation
import LyricDomainInterface
import BaseDomain
import RxSwift

public final class RemoteLyricDataSourceImpl: BaseRemoteDataSource<LyricAPI>, RemoteLyricDataSource {
    public func fetchDecoratingBackground() -> Single<[DecoratingBackgroundEntity]> {
        request(.fetchDecoratingBackground)
            .map([DecoratingBackgroundResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }
}
