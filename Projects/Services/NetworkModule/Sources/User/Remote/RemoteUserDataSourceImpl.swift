import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteUserDataSourceImpl: BaseRemoteDataSource<UserAPI>, RemoteUserDataSource {
    public func fetchUserInfo() -> Single<UserInfoEntity> {
        return request(.fetchUserInfo)
            .map(FetchUserResponseDTO.self)
            .map{$0.toDomain()}
    }
    

    public func fetchProfileList() -> Single<[ProfileListEntity]> {
        return request(.fetchProfileList)
            .map([FetchProfileListResponseDTO].self)
            .map{$0.map({$0.toDomain()})}
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
    
    public func fetchPlayList() -> Single<[PlayListEntity]> {
        return request(.fetchPlayList)
            .map([PlayListResponseDTO].self)
            .map({$0.map{$0.toDomain()}})
    }
    
    public func fetchFavoriteSong() -> Single<[FavoriteSongEntity]> {
        return request(.fetchFavoriteSongs)
            .map([FavoriteSongsResponseDTO].self)
            .map({$0.map({$0.toDomain()})})
    }
    
    public func editFavoriteSongsOrder(ids: [String]) -> Single<BaseEntity> {
        return request(.editFavoriteSongsOrder(ids: ids))
            .map(BaseResponseDTO.self)
            .map{$0.toDomain()}
    }
    
    public func editPlayListOrder(ids: [String]) -> Single<BaseEntity> {
        request(.editPlayListOrder(ids: ids))
            .map(BaseResponseDTO.self)
            .map{$0.toDomain()}
    }
    
    public func deletePlayList(ids: [String]) -> Single<BaseEntity> {
        request(.deletePlayList(ids: ids))
            .map(BaseResponseDTO.self)
            .map{$0.toDomain()}
    }
    
    public func deleteFavoriteList(ids: [String]) -> Single<BaseEntity> {
        request(.deleteFavoriteList(ids: ids))
            .map(BaseResponseDTO.self)
            .map{$0.toDomain()}
    }
    
    public func withdrawUserInfo() -> Single<BaseEntity> {
        request(.withdrawUserInfo)
            .map(BaseResponseDTO.self)
            .map{$0.toDomain()}
            
    }
}
