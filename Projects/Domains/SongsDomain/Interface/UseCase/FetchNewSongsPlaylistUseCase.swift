import Foundation
import RxSwift

public protocol FetchNewSongsPlaylistUseCase: Sendable {
    func execute(type: NewSongGroupType) -> Single<NewSongsPlaylistEntity>
}
