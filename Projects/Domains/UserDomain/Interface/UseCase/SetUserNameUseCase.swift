import BaseDomainInterface
import Foundation
import RxSwift

public protocol SetUserNameUseCase: Sendable {
    func execute(name: String) -> Completable
}
