import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteSearchDataSourceImpl: BaseRemoteDataSource<SongsAPI>, RemoteSearchDataSource {
    public func fetchSearchSong(type: SearchType, keyword: String) ->  Single<[SongEntity]> {
        request(.fetchSearchSong(type: type, keyword: keyword))
            .map([SingleSongResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
            
            
    }
    
    public func fetchLyrics(id: String) -> Single<[LyricsEntity]> {
        request(.fetchLyrics(id: id))
            .map([LyricsResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
    }
 
}
