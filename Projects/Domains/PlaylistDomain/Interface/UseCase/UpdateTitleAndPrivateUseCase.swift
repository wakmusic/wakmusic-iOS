import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdateTitleAndPrivateUseCase: Sendable {
    func execute(key: String, title: String?, isPrivate: Bool?) -> Completable
}
