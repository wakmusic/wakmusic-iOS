import BaseDomainInterface
import Foundation
import RxSwift

public protocol CheckSubscriptionUseCase: Sendable {
    func execute(key: String) -> Single<Bool>
}
