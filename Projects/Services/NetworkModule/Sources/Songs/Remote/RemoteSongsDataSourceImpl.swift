import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteSongsDataSourceImpl: BaseRemoteDataSource<SongsAPI>, RemoteSongsDataSource {
    public func fetchSearchSong(type: SearchType, keyword: String) -> Single<[SongEntity]> {
        request(.fetchSearchSong(type: type, keyword: keyword))
            .map([SingleSongResponseDTO].self)
            .map{$0.map{$0.toDomain()}}            
    }
    
    public func fetchNewSong(type: NewSongGroupType) -> Single<[NewSongEntity]> {
        request(.fetchNewSong(type: type))
            .map([NewSongResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
    }
    
    public func fetchLyrics(id: String) -> Single<[LyricsEntity]> {
        request(.fetchLyrics(id: id))
            .map([LyricsResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
    }
    
    public func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]> {
        request(.fetchNewSongs(type: type, page: page, limit: limit))
            .map([NewSongsResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
    }
}
