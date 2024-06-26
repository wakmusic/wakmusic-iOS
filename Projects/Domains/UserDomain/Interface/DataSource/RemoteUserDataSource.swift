import BaseDomainInterface
import Foundation
import RxSwift

public protocol RemoteUserDataSource {
    func setProfile(image: String) -> Single<BaseEntity>
    func setUserName(name: String) -> Single<BaseEntity>
    func fetchPlayList() -> Single<[PlayListEntity]>
    func fetchFavoriteSong() -> Single<[FavoriteSongEntity]>
    func editFavoriteSongsOrder(ids: [String]) -> Single<BaseEntity>
    func editPlayListOrder(ids: [String]) -> Single<BaseEntity>
    func deletePlayList(ids: [String]) -> Single<BaseEntity>
    func deleteFavoriteList(ids: [String]) -> Single<BaseEntity>
    func fetchUserInfo() -> Single<UserInfoEntity>
    func withdrawUserInfo() -> Single<BaseEntity>
}
