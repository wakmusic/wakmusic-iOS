import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdatePlaylist {
    func execute(key: String, songs: [String]) -> Single<BaseEntity>
}
