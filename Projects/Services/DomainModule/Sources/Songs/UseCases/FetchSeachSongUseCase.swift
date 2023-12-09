import Foundation
import RxSwift
import DataMappingModule

public protocol FetchSearchSongUseCase {
    func execute(keyword: String) -> Single<SearchResultEntity>
}
