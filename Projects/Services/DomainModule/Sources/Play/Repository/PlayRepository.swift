import DataMappingModule
import ErrorModule
import Foundation
import RxSwift

public protocol PlayRepository {
    func postPlaybackLog(item: Data) -> Single<PlaybackLogEntity>
}
