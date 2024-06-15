import Foundation
import RxSwift
import SongsDomainInterface

public protocol FetchSearchSongUseCase {
    func execute(order: SortType, filter: FilterType, text: String, page: Int, limit: Int) -> Single<[SongEntity]>
}
