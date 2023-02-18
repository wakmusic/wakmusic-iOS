import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteUserDataSourceImpl: BaseRemoteDataSource<UserAPI>, RemoteUserDataSource {
  
  
    public func setProfile(token: String, image: String) -> Single<BaseEntity> {
        
        return request(.setProfile(token: token, image: image))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func setUserName(token: String, name: String) -> Single<BaseEntity> {
        
        return request(.setUserName(token: token, name: name))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func fetchSubPlayList(token: String) -> Single<[SubPlayListEntity]> {
        
        return request(.fetchSubPlayList(token: token))
            .map([SubPlayListResponseDTO].self)
            .map({$0.map{$0.toDomain()}})
        
    }
    
    public func fetchFavoriteSong(token: String) -> Single<[FavoriteSongEntity]> {
    
        return request(.fetchFavoriteSongs(token: token))
            .map([FavoriteSongsResponseDTO].self)
            .map({$0.map({$0.toDomain()})})
    }
    
    
    
    
   
    

}
