import Foundation
import PlaylistDomainInterface
import RxSwift

public protocol FetchSearchPlaylistsUseCase: Sendable {
    func execute(order: SortType, text: String, page: Int, limit: Int) -> Single<[SearchPlaylistEntity]>
}
