import BaseDomainInterface
import Foundation
import RxSwift

public protocol SubscribePlaylistUseCase {
    func execute(key: String) -> Completable
}
