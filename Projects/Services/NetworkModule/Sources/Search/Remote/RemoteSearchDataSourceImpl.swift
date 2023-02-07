import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation


public final class RemoteSearchDataSourceImpl: BaseRemoteDataSource<SearchAPI>, RemoteSearchDataSource {
    public func fetchSearchSong(type: SearchType, keyword: String) ->  Single<[SearchEntity]> {
        request(.fetchSearchSong(type: type, keyword: keyword))
            .map(FetchSearchSongResponseDTO.self)
            .map { $0.toDomain() }
    }
    
 
}
