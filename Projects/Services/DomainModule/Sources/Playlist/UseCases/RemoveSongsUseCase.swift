import Foundation
import RxSwift
import DataMappingModule

public protocol RemoveSongsUseCase {
    func execute(key: String,songs: [String]) -> Single<BaseEntity>
}
