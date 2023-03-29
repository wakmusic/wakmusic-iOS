import Foundation
import RxSwift
import DataMappingModule

public protocol DeletePlayListUseCase {
    func execute(ids: [String]) -> Single<BaseEntity>
}
