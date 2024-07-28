import Foundation
import RxSwift

public protocol FetchFavoriteSongsUseCase {
    func execute() -> Single<[FavoriteSongEntity]>
}
