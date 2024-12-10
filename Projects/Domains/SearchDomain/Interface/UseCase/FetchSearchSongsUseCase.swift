import Foundation
import RxSwift
import SongsDomainInterface

public protocol FetchSearchSongsUseCase: Sendable {
    func execute(order: SortType, filter: FilterType, text: String, page: Int, limit: Int) -> Single<[SongEntity]>
}
