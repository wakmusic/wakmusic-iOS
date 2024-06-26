import Foundation
import RxSwift

public protocol CreatePlaylistUseCase {
    func execute(title: String) -> Single<PlaylistBaseEntity>
}
