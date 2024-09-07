import BaseDomainInterface
import Foundation
import RxSwift

public protocol RequestCustomImageURLUseCase {
    func execute(key: String, data: Data) -> Completable
}
