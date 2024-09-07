import Foundation
import RxSwift

public protocol FetchSongUseCase {
    func execute(id: String) -> Single<SongDetailEntity>
}
