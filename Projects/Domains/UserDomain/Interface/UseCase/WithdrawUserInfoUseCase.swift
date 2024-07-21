import BaseDomainInterface
import Foundation
import RxSwift

public protocol WithdrawUserInfoUseCase {
    func execute() -> Completable
}
