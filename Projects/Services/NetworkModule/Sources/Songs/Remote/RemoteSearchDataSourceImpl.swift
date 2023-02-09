import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteSearchDataSourceImpl: BaseRemoteDataSource<SongsAPI>, RemoteSearchDataSource {
    public func fetchSearchSong(type: SearchType, keyword: String) ->  Single<[SearchEntity]> {
        request(.fetchSearchSong(type: type, keyword: keyword))
            .map([SingleSearchSongResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
            
            
    }
    
 
}
