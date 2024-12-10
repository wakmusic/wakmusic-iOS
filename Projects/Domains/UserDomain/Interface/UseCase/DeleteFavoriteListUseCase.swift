import BaseDomainInterface
import Foundation
import RxSwift

public protocol DeleteFavoriteListUseCase: Sendable {
    func execute(ids: [String]) -> Completable
}
