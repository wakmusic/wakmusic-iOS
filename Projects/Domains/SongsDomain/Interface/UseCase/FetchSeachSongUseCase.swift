import Foundation
import RxSwift

public protocol FetchSearchSongUseCase {
    func execute(keyword: String) -> Single<SearchResultEntity>
}
