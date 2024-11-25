import BaseDomainInterface
import Foundation
import RxSwift

public protocol RequestCustomImageURLUseCase: Sendable {
    func execute(key: String, data: Data) -> Completable
}
