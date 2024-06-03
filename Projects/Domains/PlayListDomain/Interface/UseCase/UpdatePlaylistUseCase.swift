import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdatePlaylistUseCase {
    func execute(key: String, songs: [String]) -> Completable
}
