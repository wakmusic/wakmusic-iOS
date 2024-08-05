import Foundation
import RxSwift

public protocol FetchNewSongsPlaylistUseCase {
    func execute(type: NewSongGroupType) -> Single<NewSongsPlaylistEntity>
}
