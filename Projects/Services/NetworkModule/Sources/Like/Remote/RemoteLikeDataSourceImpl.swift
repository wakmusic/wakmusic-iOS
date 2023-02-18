import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteLikeDataSourceImpl: BaseRemoteDataSource<LikeAPI>, RemoteLikeDataSource {
    
    public func fetchLikeNumOfSong(id: String) -> Single<FavoriteSongEntity> {
        request(.fetchLikeNumOfSong(id: id))
            .map(FavoriteSongsResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func addLikeSong(id: String) -> Single<BaseEntity> {
        request(.addLikeSong(id: id))
            .map(BaseResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func cancelLikeSong(id: String) -> Single<BaseEntity> {
        request(.cancelLikeSong(id: id))
            .map(BaseResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    

    
    
 
}
