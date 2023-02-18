import Foundation
import RxSwift
import DataMappingModule

public protocol CreatePlayListUseCase {
    func execute(title:String) -> Single<PlayListBaseEntity>
}
