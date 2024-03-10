import Foundation
import RxSwift
import BaseDomainInterface

public protocol RemoveSongsUseCase {
    func execute(key: String, songs: [String]) -> Single<BaseEntity>
}
