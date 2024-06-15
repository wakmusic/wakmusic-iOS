import RxSwift
import SearchDomainInterface
import SongsDomainInterface

public struct FetchSearchPlaylistsUseCaseImpl: FetchSearchPlaylistsUseCase {
    private let searchRepository: any SearchRepository

    public init(
        searchRepository: SearchRepository
    ) {
        self.searchRepository = searchRepository
    }

    public func execute(order: SortType, text: String, page: Int, limit: Int) -> Single<[SearchPlaylistEntity]> {
        return searchRepository.fetchSearchPlaylist(order: order, text: text, page: page, limit: limit)
    }
}
