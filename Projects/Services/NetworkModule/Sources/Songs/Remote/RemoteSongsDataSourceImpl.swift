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
}
