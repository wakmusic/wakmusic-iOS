import Foundation
import RxSwift

public protocol FetchPlaylistDetailUseCase {
    func execute(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity>
}
