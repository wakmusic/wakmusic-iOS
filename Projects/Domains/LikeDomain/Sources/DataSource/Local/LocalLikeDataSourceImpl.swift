import Foundation
import LikeDomainInterface
import RxSwift
import Utility

public final class LocalLikeDataSourceImpl: LocalLikeDataSource {
    public init() {}

    public func addLikeSong(id: String) -> Completable {
        Completable.create { observer in
            RealmManager.shared.addRealmDB(model: LocalLikeEntity(songID: id))
            observer(.completed)
            return Disposables.create()
        }
    }

    public func cancelLikeSong(id: String) -> Completable {
        Completable.create { observer in
            let deletingLocalLikeEntity = RealmManager.shared.fetchRealmDB(LocalLikeEntity.self, primaryKey: id)

            if let deletingLocalLikeEntity {
                RealmManager.shared.deleteRealmDB(model: [deletingLocalLikeEntity])
            }

            observer(.completed)
            return Disposables.create()
        }
    }

    public func checkIsLikedSong(id: String) -> Single<Bool> {
        let likedSong = RealmManager.shared.fetchRealmDB(LocalLikeEntity.self, primaryKey: id)
        return .just(likedSong != nil)
    }

    public func updateLikedSongs(ids: [String]) -> Completable {
        Completable.create { observer in
            let deletingLocalLikeEntity = RealmManager.shared.fetchRealmDB(LocalLikeEntity.self)
            RealmManager.shared.deleteRealmDB(model: deletingLocalLikeEntity)

            let addingLocalLikeEntity = ids
                .map { LocalLikeEntity(songID: $0) }
            RealmManager.shared.addRealmDB(model: addingLocalLikeEntity)

            observer(.completed)
            return Disposables.create()
        }
    }
}
