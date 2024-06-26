import BaseDomainInterface
import Foundation
import RxSwift

public protocol RemoveSongsUseCase {
    func execute(key: String, songs: [String]) -> Completable
}
