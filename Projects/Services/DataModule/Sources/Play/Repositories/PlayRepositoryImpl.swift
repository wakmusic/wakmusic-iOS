import DatabaseModule
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import NetworkModule
import RxSwift

public struct PlayRepositoryImpl: PlayRepository {
    private let remotePlayDataSource: any RemotePlayDataSource

    public init(
        remotePlayDataSource: RemotePlayDataSource
    ) {
        self.remotePlayDataSource = remotePlayDataSource
    }

    public func postPlaybackLog(item: Data) -> Single<PlaybackLogEntity> {
        remotePlayDataSource.postPlaybackLog(item: item)
    }
}
