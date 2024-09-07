import BaseDomainInterface
import Foundation
import RxSwift

public protocol EditPlaylistOrderUseCase {
    func execute(ids: [String]) -> Completable
}
