import BaseDomainInterface
import Foundation
import RxSwift

public protocol DeleteFavoriteListUseCase {
    func execute(ids: [String]) -> Completable
}
