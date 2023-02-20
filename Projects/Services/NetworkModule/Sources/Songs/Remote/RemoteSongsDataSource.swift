import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteSongsDataSource {
    func fetchSearchSong(type: SearchType,keyword: String) -> Single<[SongEntity]>
    func fetchNewSong(type: NewSongGroupType) -> Single<[NewSongEntity]>
}
