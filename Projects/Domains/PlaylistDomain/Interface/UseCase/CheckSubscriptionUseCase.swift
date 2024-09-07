import BaseDomainInterface
import Foundation
import RxSwift

public protocol CheckSubscriptionUseCase {
    func execute(key: String) -> Single<Bool>
}
