import Foundation
import RxSwift
import DataMappingModule

public protocol FetchSearchSongUseCase {
    func execute(type: SearchType,keyword: String) -> Single<[SongEntity]>
}
