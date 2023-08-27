import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol PlayRepository {
    func postPlaybackLog(item: Data) -> Single<PlaybackLogEntity>
}
