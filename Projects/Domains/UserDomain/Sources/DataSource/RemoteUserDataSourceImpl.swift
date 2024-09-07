import BaseDomain
import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public final class RemoteUserDataSourceImpl: BaseRemoteDataSource<UserAPI>, RemoteUserDataSource {
    public func fetchUserInfo() -> Single<UserInfoEntity> {
        return request(.fetchUserInfo)
            .map(FetchUserResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func setProfile(image: String) -> Completable {
        return request(.setProfile(image: image))
            .asCompletable()
    }

    public func setUserName(name: String) -> Completable {
        return request(.setUserName(name: name))
            .asCompletable()
    }

    public func fetchPlaylist() -> Single<[PlaylistEntity]> {
        return request(.fetchPlaylist)
            .map([PlaylistResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }

    public func fetchFavoriteSong() -> Single<[FavoriteSongEntity]> {
        return request(.fetchFavoriteSongs)
            .map([FavoriteSongsResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func editFavoriteSongsOrder(ids: [String]) -> Completable {
        return request(.editFavoriteSongsOrder(ids: ids))
            .asCompletable()
    }

    public func editPlaylistOrder(ids: [String]) -> Completable {
        request(.editPlaylistOrder(ids: ids))
            .asCompletable()
    }

    public func deletePlaylist(ids: [String]) -> Completable {
        request(.deletePlaylist(ids: ids))
            .asCompletable()
    }

    public func deleteFavoriteList(ids: [String]) -> Completable {
        request(.deleteFavoriteList(ids: ids))
            .asCompletable()
    }

    public func withdrawUserInfo() -> Completable {
        request(.withdrawUserInfo)
            .asCompletable()
    }

    public func fetchFruitList() -> Single<[FruitEntity]> {
        return request(.fetchFruitList)
            .map([FruitListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchFruitDrawStatus() -> Single<FruitDrawStatusEntity> {
        return request(.fetchFruitDrawStatus)
            .map(FruitDrawStatusResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func drawFruit() -> Single<FruitEntity> {
        return request(.drawFruit)
            .map(FruitListResponseDTO.self)
            .map { $0.toDomain() }
    }
}
