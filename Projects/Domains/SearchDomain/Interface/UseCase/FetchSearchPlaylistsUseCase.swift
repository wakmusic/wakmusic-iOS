import Foundation
import RxSwift
import PlayListDomainInterface

public protocol FetchSearchPlaylistsUseCase {
    func execute(order: SortType, text: String, page: Int, limit: Int) -> Single<[SearchPlaylistEntity]>
}
