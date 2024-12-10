import Foundation
import RxSwift

public protocol FetchSongUseCase: Sendable {
    func execute(id: String) -> Single<SongDetailEntity>
}
