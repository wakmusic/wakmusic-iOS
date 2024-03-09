import DataMappingModule
import Foundation
import RxSwift

public protocol RemoveSongsUseCase {
    func execute(key: String, songs: [String]) -> Single<BaseEntity>
}
