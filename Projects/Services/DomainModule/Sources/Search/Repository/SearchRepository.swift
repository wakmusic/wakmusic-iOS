import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol SearchRepository {
    func fetchSeachSong(type: SearchType, limit: Int) -> Single<[SearchEntity]>
}
