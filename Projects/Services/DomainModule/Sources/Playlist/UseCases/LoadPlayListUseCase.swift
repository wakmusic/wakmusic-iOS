import Foundation
import RxSwift
import DataMappingModule

public protocol LoadPlayListUseCase {
    func execute(key: String) -> Single<PlayListBaseEntity>
}
