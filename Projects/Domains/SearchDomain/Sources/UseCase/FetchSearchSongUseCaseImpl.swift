import SearchDomainInterface
import SongsDomainInterface
import RxSwift

public struct FetchSearchSongUseCaseImpl: FetchSearchSongUseCase {

    private let searchRepository: any SearchRepository

    public init(
        searchRepository: SearchRepository
    ) {
        self.searchRepository = searchRepository
    }
    
    public func execute(order: SortType, filter: FilterType, text: String, page: Int, limit: Int) -> Single<[SongEntity]> {
        return searchRepository.fetchSearchSongs(order: order, filter: filter, text: text, page: page, limit: limit)
    }
}
