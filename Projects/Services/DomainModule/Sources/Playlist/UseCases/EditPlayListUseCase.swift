import Foundation
import RxSwift
import DataMappingModule

public protocol EditPlayListUseCase {
    func execute(key: String,songs: [String]) -> Single<BaseEntity>
}
