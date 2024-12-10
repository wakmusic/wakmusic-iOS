import BaseDomainInterface
import Foundation
import RxSwift

public protocol SetProfileUseCase: Sendable {
    func execute(image: String) -> Completable
}
