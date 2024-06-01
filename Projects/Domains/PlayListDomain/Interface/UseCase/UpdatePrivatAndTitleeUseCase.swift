import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdatePrivatAndTitleeUseCase {
    func execute(key: String) -> Completable
}
