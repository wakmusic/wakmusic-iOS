import APIKit
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public final class RemotePlayDataSourceImpl: BaseRemoteDataSource<PlayAPI>, RemotePlayDataSource {
    public func postPlaybackLog(item: Data) -> Single<PlaybackLogEntity> {
        request(.postPlaybackLog(item: item))
            .map(PlaybackLogResponseDTO.self)
            .map { $0.toDomain() }
    }
}
