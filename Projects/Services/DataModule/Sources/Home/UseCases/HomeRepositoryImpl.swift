import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct HomeRepositoryImpl: HomeRepository {
    private let remoteNewSongDataSource: any RemoteNewSongDataSource
    
    public init(
        remoteNewSongDataSource: RemoteNewSongDataSource
    ) {
        self.remoteNewSongDataSource = remoteNewSongDataSource
    }
    
    public func fetchNewSong(type: NewSongGroupType) -> Single<[NewSongEntity]> {
        remoteNewSongDataSource.fetchNewSong(type: type)
    }
}
