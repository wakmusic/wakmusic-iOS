import Foundation
import RxSwift
import DataMappingModule

public protocol EditPlayListNameUseCase {
    func execute(key: String,title:String) -> Single<BaseEntity>
}
