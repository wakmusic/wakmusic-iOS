import BaseDomainInterface
import Foundation
import RxSwift

public protocol RequestPlaylistOwnerIDUsecase: Sendable {
    func execute(key: String) -> Single<PlaylistOwnerIDEntity>
}
