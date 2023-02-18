import Foundation
import RxSwift
import DataMappingModule

public protocol LoadPlayListUseCase {
    func execute() -> Single<PlayListBaseEntity>
}
