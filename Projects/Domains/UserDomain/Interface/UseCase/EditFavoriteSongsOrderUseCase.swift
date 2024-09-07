import BaseDomainInterface
import Foundation
import RxSwift

public protocol EditFavoriteSongsOrderUseCase {
    func execute(ids: [String]) -> Completable
}
