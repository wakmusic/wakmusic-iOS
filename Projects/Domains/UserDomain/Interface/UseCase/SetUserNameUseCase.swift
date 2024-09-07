import BaseDomainInterface
import Foundation
import RxSwift

public protocol SetUserNameUseCase {
    func execute(name: String) -> Completable
}
