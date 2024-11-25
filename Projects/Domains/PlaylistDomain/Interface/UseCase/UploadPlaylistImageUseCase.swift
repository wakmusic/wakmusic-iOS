import BaseDomainInterface
import Foundation
import RxSwift

public protocol UploadDefaultPlaylistImageUseCase: Sendable {
    func execute(key: String, model: String) -> Completable
}
