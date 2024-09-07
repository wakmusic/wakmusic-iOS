import BaseDomainInterface
import Foundation
import RxSwift

public protocol UploadDefaultPlaylistImageUseCase {
    func execute(key: String, model: String) -> Completable
}
