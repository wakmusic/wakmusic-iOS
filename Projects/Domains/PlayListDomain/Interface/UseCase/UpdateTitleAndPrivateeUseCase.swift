import BaseDomainInterface
import Foundation
import RxSwift

public protocol UpdateTitleAndPrivateeUseCase {
    func execute(key: String, title: String?, isPrivate: Bool?) -> Completable
}
