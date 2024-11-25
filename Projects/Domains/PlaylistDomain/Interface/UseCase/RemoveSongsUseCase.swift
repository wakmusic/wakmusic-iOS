import BaseDomainInterface
import Foundation
import RxSwift

public protocol RemoveSongsUseCase: Sendable {
    func execute(key: String, songs: [String]) -> Completable
}
