import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteUserDataSourceImpl: BaseRemoteDataSource<UserAPI>, RemoteUserDataSource {
    
    
  
    public func fetchProfileList() -> Single<[ProfileListEntity]> {
        return request(.fetchProfileList)
            .map([String].self)
            .map { $0.map { ProfileListEntity(id: $0, isSelected: false) }}
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
    
    public func fetchSubPlayList() -> Single<[SubPlayListEntity]> {
        
        return request(.fetchSubPlayList)
            .map([SubPlayListResponseDTO].self)
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
    
    
    
    
    
   
    

}
