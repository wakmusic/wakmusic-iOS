import Foundation
import RxSwift

public protocol AddSongIntoPlaylistUseCase {
    func execute(key: String, songs: [String]) -> Single<AddSongEntity>
}
