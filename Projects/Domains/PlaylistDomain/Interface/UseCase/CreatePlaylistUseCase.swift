import Foundation
import RxSwift

public protocol CreatePlaylistUseCase: Sendable {
    func execute(title: String) -> Single<PlaylistBaseEntity>
}
