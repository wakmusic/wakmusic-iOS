import BaseDomainInterface
import Foundation
import RxSwift

public protocol RequestPlaylistOwnerIDUsecase {
    func execute(key: String) -> Single<PlaylistOwnerIDEntity>
}
