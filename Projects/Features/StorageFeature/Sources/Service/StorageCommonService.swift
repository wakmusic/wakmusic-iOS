import Foundation
import RxSwift

protocol StorageCommonService {
    var isEditingState: BehaviorSubject<Bool> { get }
}

final class DefaultStorageCommonService: StorageCommonService {
    let isEditingState: BehaviorSubject<Bool> = .init(value: false)

    static let shared = DefaultStorageCommonService()
}
