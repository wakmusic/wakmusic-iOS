import Foundation
import RxSwift

public protocol FetchArtistSongListUseCase: Sendable {
    func execute(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]>
}
