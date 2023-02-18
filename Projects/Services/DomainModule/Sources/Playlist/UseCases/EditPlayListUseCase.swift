import Foundation
import RxSwift
import DataMappingModule

public protocol EditPlayListUseCase {
    func execute() -> Single<BaseEntity>
}
