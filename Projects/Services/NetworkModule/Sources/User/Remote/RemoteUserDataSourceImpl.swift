import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteUserDataSourceImpl: BaseRemoteDataSource<UserAPI>, RemoteUserDataSource {
  
  
    public func setProfile(token: String, image: String) -> Completable {
        
        return request(.setProfile(token: token, image: image))
            .asCompletable()
    }
    
    public func setUserName(token: String, name: String) -> Completable {
        
        return request(.setUserName(token: token, name: name))
            .asCompletable()
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
