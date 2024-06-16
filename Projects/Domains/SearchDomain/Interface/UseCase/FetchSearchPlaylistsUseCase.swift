import Foundation
import PlayListDomainInterface
import RxSwift

public protocol FetchSearchPlaylistsUseCase {
    func execute(order: SortType, text: String, page: Int, limit: Int) -> Single<[SearchPlaylistEntity]>
}
