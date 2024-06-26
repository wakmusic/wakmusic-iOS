import Foundation
import RxSwift

public protocol FetchPlayListDetailUseCase {
    func execute(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity>
}
