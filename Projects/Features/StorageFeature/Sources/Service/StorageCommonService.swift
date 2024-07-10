import Foundation
import RxSwift
import Utility

protocol StorageCommonService {
    var isEditingState: BehaviorSubject<Bool> { get }
    var changedUserInfoEvent: Observable<UserInfo?> { get }
}

final class DefaultStorageCommonService: StorageCommonService {
    let isEditingState: BehaviorSubject<Bool> = .init(value: false)
    let changedUserInfoEvent: Observable<UserInfo?> = PreferenceManager.$userInfo

    static let shared = DefaultStorageCommonService()
}
