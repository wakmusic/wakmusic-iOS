import BaseDomainInterface
import Foundation
import RxSwift

public protocol EditPlaylistOrderUseCase: Sendable {
    func execute(ids: [String]) -> Completable
}
