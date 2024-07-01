import ArtistDomainInterface
import Foundation
import RxSwift

public struct FetchArtistSongListUseCaseImpl: FetchArtistSongListUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]> {
        artistRepository.fetchArtistSongList(id: id, sort: sort, page: page)
    }
}
