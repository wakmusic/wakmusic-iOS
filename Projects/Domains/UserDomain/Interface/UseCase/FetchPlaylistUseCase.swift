import Foundation
import RxSwift

public protocol FetchPlaylistUseCase: Sendable {
    func execute() -> Single<[PlaylistEntity]>
}
