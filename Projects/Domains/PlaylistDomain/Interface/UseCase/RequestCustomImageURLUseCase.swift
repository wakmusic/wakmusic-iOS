import BaseDomainInterface
import Foundation
import RxSwift

public protocol RequestCustomImageURLUseCase {
    func execute(key: String, imageSize: Int) -> Single<CustomImageUrlEntity>
}
