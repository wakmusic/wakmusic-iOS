import Foundation
import RxSwift

public protocol FetchWmPlaylistDetailUseCase {
    func execute(id: String) -> Single<WmPlaylistDetailEntity>
}
