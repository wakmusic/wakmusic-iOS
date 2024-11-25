import BaseDomainInterface
import Foundation
import RxSwift

public protocol UserRepository: Sendable {
    func setProfile(image: String) -> Completable
    func setUserName(name: String) -> Completable
    func fetchPlaylist() -> Single<[PlaylistEntity]>
    func fetchFavoriteSongs() -> Single<[FavoriteSongEntity]>
    func editFavoriteSongsOrder(ids: [String]) -> Completable
    func editPlaylistOrder(ids: [String]) -> Completable
    func deletePlaylist(ids: [String]) -> Completable
    func deleteFavoriteList(ids: [String]) -> Completable
    func fetchUserInfo() -> Single<UserInfoEntity>
    func withdrawUserInfo() -> Completable
    func fetchFruitList() -> Single<[FruitEntity]>
    func fetchFruitDrawStatus() -> Single<FruitDrawStatusEntity>
    func drawFruit() -> Single<FruitEntity>
}
