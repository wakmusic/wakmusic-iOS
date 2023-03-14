import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct SongsRepositoryImpl: SongsRepository {
    private let remoteSearchDataSource: any RemoteSearchDataSource
    
    public init(
        remoteSearchDataSource: RemoteSearchDataSource
    ) {
        self.remoteSearchDataSource = remoteSearchDataSource
    }
    
    public func fetchSearchSong(type: SearchType, keyword: String) -> Single<[SongEntity]> {
        remoteSearchDataSource.fetchSearchSong(type: type, keyword: keyword)
    }
    
    public func fetchLyrics(id: String) -> Single<[LyricsEntity]> {
        remoteSearchDataSource.fetchLyrics(id: id)
    }
    public func fetchNewSong(type: NewSongGroupType) -> Single<[NewSongEntity]> {
        remoteSongsDataSource.fetchNewSong(type: type)
    }
}