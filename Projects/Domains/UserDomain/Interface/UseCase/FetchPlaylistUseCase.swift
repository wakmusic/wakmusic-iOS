import Foundation
import RxSwift

public protocol FetchPlaylistUseCase {
    func execute() -> Single<[PlaylistEntity]>
}
