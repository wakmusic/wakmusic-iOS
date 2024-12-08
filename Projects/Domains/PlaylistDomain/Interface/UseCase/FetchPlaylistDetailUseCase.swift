import Foundation
import RxSwift

public protocol FetchPlaylistDetailUseCase: Sendable {
    func execute(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity>
}
