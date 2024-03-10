import Foundation
import RxSwift

public protocol AddSongIntoPlayListUseCase {
    func execute(key: String, songs: [String]) -> Single<AddSongEntity>
}
