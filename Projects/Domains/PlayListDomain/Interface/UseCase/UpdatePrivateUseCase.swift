import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdatePrivateUseCase {
    func execute(key: String) -> Completable
}
