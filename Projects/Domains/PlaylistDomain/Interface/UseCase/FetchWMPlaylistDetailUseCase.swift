import Foundation
import RxSwift

public protocol FetchWMPlaylistDetailUseCase: Sendable {
    func execute(id: String) -> Single<WMPlaylistDetailEntity>
}
