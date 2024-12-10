import Foundation
import RxSwift

public protocol FetchFavoriteSongsUseCase: Sendable {
    func execute() -> Single<[FavoriteSongEntity]>
}
