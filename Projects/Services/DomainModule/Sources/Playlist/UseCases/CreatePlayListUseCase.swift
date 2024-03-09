import DataMappingModule
import Foundation
import RxSwift

public protocol CreatePlayListUseCase {
    func execute(title: String) -> Single<PlayListBaseEntity>
}
