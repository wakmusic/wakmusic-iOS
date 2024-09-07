import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdateTitleAndPrivateUseCase {
    func execute(key: String, title: String?, isPrivate: Bool?) -> Completable
}
