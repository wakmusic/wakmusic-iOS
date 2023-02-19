import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol SearchRepository {
    func fetchSearchSong(type: SearchType, keyword: String) -> Single<[SongEntity]>
}
