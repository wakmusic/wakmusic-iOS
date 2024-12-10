import BaseDomainInterface
import Foundation
import RxSwift

public protocol EditFavoriteSongsOrderUseCase: Sendable {
    func execute(ids: [String]) -> Completable
}
