import BaseDomainInterface
import Foundation
import RxSwift

public protocol FetchCustomImageUrlUseCase {
    func execute(key: String, imageSize: Int) -> Single<CustomImageUrlEntity>
}
