import DataMappingModule
import Foundation
import RxSwift

public protocol EditPlayListNameUseCase {
    func execute(key: String, title: String) -> Single<EditPlayListNameEntity>
}
