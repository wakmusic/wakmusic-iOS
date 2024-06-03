import BaseDomainInterface
import Foundation
import RxSwift

public protocol UploadPlaylistImageUseCase {
    func execute(key: String, model: UploadImageType) -> Single<BaseImageEntity>
}
