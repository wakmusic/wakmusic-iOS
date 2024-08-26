import Foundation
import RxSwift

public protocol FetchWMPlaylistDetailUseCase {
    func execute(id: String) -> Single<WMPlaylistDetailEntity>
}
