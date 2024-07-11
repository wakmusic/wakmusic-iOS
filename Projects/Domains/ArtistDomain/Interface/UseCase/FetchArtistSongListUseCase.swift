import Foundation
import RxSwift

public protocol FetchArtistSongListUseCase {
    func execute(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]>
}
