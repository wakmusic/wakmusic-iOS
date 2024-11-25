import Foundation
import RxSwift

public protocol AddSongIntoPlaylistUseCase: Sendable {
    func execute(key: String, songs: [String]) -> Single<AddSongEntity>
}
