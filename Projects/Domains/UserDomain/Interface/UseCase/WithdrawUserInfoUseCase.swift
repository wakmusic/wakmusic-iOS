import BaseDomainInterface
import Foundation
import RxSwift

public protocol WithdrawUserInfoUseCase: Sendable {
    func execute() -> Completable
}
