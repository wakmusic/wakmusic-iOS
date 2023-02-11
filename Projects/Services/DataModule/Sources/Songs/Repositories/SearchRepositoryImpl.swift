import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct SearchRepositoryImpl: SearchRepository {
    private let remoteSearchDataSource: any RemoteSearchDataSource
    
    public init(
        remoteSearchDataSource: RemoteSearchDataSource
    ) {
        self.remoteSearchDataSource = remoteSearchDataSource
    }
    
    public func fetchSearchSong(type: SearchType, keyword: String) -> Single<[SongEntity]> {
        remoteSearchDataSource.fetchSearchSong(type: type, keyword: keyword)
    }

}
