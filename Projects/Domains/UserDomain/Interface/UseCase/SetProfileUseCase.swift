import BaseDomainInterface
import Foundation
import RxSwift

public protocol SetProfileUseCase {
    func execute(image: String) -> Completable
}
