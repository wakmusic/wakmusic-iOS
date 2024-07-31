import BaseDomainInterface
import Foundation
import RxSwift

public protocol RequestPlaylistOwnerIdUsecase {
    func execute(key: String) -> Single<PlaylistOwnerIdEntity>
}
