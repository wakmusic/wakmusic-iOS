import BaseDomainInterface
import ErrorModule
import LikeDomainInterface
import RxSwift
import UserDomainInterface
import Utility

public final class UserRepositoryImpl: UserRepository {
    private let remoteUserDataSource: any RemoteUserDataSource

    public init(remoteUserDataSource: any RemoteUserDataSource) {
        self.remoteUserDataSource = remoteUserDataSource
    }

    public func fetchUserInfo() -> Single<UserInfoEntity> {
        remoteUserDataSource.fetchUserInfo()
            .do(onSuccess: { entity in
                PreferenceManager.shared.setUserInfo(
                    ID: entity.id,
                    platform: entity.platform,
                    profile: entity.profile,
                    name: entity.name,
                    itemCount: entity.itemCount
                )
            })
    }

    public func setProfile(image: String) -> Completable {
        remoteUserDataSource.setProfile(image: image)
    }

    public func setUserName(name: String) -> Completable {
        remoteUserDataSource.setUserName(name: name)
    }

    public func fetchPlaylist() -> Single<[PlaylistEntity]> {
        remoteUserDataSource.fetchPlaylist()
    }

    public func fetchFavoriteSongs() -> Single<[FavoriteSongEntity]> {
        remoteUserDataSource.fetchFavoriteSong()
    }

    public func editFavoriteSongsOrder(ids: [String]) -> Completable {
        remoteUserDataSource.editFavoriteSongsOrder(ids: ids)
    }

    public func editPlaylistOrder(ids: [String]) -> Completable {
        remoteUserDataSource.editPlaylistOrder(ids: ids)
    }

    public func deletePlaylist(ids: [String]) -> Completable {
        remoteUserDataSource.deletePlaylist(ids: ids)
    }

    public func deleteFavoriteList(ids: [String]) -> Completable {
        remoteUserDataSource.deleteFavoriteList(ids: ids)
    }

    public func withdrawUserInfo() -> Completable {
        remoteUserDataSource.withdrawUserInfo()
    }

    public func fetchFruitList() -> Single<[FruitEntity]> {
        remoteUserDataSource.fetchFruitList()
    }

    public func fetchFruitDrawStatus() -> Single<FruitDrawStatusEntity> {
        remoteUserDataSource.fetchFruitDrawStatus()
    }

    public func drawFruit() -> Single<FruitEntity> {
        remoteUserDataSource.drawFruit()
    }
}
