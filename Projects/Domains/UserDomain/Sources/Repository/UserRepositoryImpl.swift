import BaseDomainInterface
import ErrorModule
import RxSwift
import UserDomainInterface

public final class UserRepositoryImpl: UserRepository {
    private let remoteUserDataSource: any RemoteUserDataSource

    public init(
        remoteUserDataSource: RemoteUserDataSource
    ) {
        self.remoteUserDataSource = remoteUserDataSource
    }

    public func fetchUserInfo() -> Single<UserInfoEntity> {
        remoteUserDataSource.fetchUserInfo()
    }

    public func setProfile(image: String) -> Single<BaseEntity> {
        remoteUserDataSource.setProfile(image: image)
    }

    public func setUserName(name: String) -> Single<BaseEntity> {
        remoteUserDataSource.setUserName(name: name)
    }

    public func fetchPlaylist() -> Single<[PlaylistEntity]> {
        remoteUserDataSource.fetchPlaylist()
    }

    public func fetchFavoriteSongs() -> Single<[FavoriteSongEntity]> {
        remoteUserDataSource.fetchFavoriteSong()
    }

    public func editFavoriteSongsOrder(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.editFavoriteSongsOrder(ids: ids)
    }

    public func editPlaylistOrder(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.editPlaylistOrder(ids: ids)
    }

    public func deletePlaylist(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.deletePlaylist(ids: ids)
    }

    public func deleteFavoriteList(ids: [String]) -> Single<BaseEntity> {
        remoteUserDataSource.deleteFavoriteList(ids: ids)
    }

    public func withdrawUserInfo() -> Single<BaseEntity> {
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
