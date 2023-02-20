import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct SongsRepositoryImpl: SongsRepository {
    private let remoteSongsDataSource: any RemoteSongsDataSource
    
    public init(
        remoteSongsDataSource: RemoteSongsDataSource
    ) {
        self.remoteSongsDataSource = remoteSongsDataSource
    }
    
    public func fetchSearchSong(type: SearchType, keyword: String) -> Single<[SongEntity]> {
        remoteSongsDataSource.fetchSearchSong(type: type, keyword: keyword)
    }

    public func fetchNewSong(type: NewSongGroupType) -> Single<[NewSongEntity]> {
        remoteSongsDataSource.fetchNewSong(type: type)
    }
}
