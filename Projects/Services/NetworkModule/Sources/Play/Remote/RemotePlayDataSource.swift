import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public protocol RemotePlayDataSource {
    func postPlaybackLog(item: Data) -> Single<PlaybackLogEntity>
}
