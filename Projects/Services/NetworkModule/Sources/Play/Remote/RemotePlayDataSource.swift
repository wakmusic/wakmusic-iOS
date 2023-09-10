import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemotePlayDataSource {
    func postPlaybackLog(item: Data) -> Single<PlaybackLogEntity>
}
