import Foundation
import RxSwift
import PlayListDomainInterface

public protocol FetchSearchPlaylistUseCase {
    func execute(order: SortType, text: String, page: Int, limit: Int) -> Single<[SearchPlaylistEntity]>
}
