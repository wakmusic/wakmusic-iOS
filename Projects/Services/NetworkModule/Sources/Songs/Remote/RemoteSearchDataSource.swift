import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteSearchDataSource {
    func fetchSearchSong(type: SearchType,keyword: String) -> Single<[SongEntity]>
}
