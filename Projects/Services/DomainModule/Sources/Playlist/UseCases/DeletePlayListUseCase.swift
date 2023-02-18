import Foundation
import RxSwift
import DataMappingModule

public protocol DeletePlayListUseCase {
    func execute() -> Single<BaseEntity>
}
