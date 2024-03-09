import DataMappingModule
import Foundation
import RxSwift

public protocol DeletePlayListUseCase {
    func execute(ids: [String]) -> Single<BaseEntity>
}
