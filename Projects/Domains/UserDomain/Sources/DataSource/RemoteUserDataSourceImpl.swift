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

    public func setProfile(image: String) -> Single<BaseEntity> {
        return request(.setProfile(image: image))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func setUserName(name: String) -> Single<BaseEntity> {
        return request(.setUserName(name: name))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
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

    public func editFavoriteSongsOrder(ids: [String]) -> Single<BaseEntity> {
        return request(.editFavoriteSongsOrder(ids: ids))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func editPlaylistOrder(ids: [String]) -> Single<BaseEntity> {
        request(.editPlaylistOrder(ids: ids))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func deletePlaylist(ids: [String]) -> Single<BaseEntity> {
        request(.deletePlaylist(ids: ids))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func deleteFavoriteList(ids: [String]) -> Single<BaseEntity> {
        request(.deleteFavoriteList(ids: ids))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func withdrawUserInfo() -> Single<BaseEntity> {
        request(.withdrawUserInfo)
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
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
