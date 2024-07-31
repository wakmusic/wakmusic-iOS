import Foundation
import RxSwift

public protocol LocalLikeDataSource {
    func addLikeSong(id: String) -> Completable
    func cancelLikeSong(id: String) -> Completable
    func checkIsLikedSong(id: String) -> Single<Bool>
    func updateLikedSongs(ids: [String]) -> Completable
}
