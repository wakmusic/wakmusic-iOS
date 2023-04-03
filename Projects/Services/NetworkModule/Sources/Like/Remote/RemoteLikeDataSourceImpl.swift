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
    
    public func addLikeSong(id: String) -> Single<LikeEntity> {
        request(.addLikeSong(id: id))
            .map(LikeResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    public func cancelLikeSong(id: String) -> Single<LikeEntity> {
        request(.cancelLikeSong(id: id))
            .map(LikeResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    

    
    
 
}
