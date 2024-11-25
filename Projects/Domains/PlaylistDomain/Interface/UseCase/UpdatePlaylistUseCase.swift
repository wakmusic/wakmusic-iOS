import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdatePlaylistUseCase: Sendable {
    func execute(key: String, songs: [String]) -> Completable
}
