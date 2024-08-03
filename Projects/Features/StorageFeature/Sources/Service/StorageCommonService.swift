import Foundation
import RxSwift
import Utility

protocol StorageCommonService {
    var isEditingState: BehaviorSubject<Bool> { get }
    var loginStateDidChangedEvent: Observable<Notification> { get }
}

final class DefaultStorageCommonService: StorageCommonService {
    let isEditingState: BehaviorSubject<Bool>
    let loginStateDidChangedEvent: Observable<Notification>
    
    init() {
        let notificationCenter = NotificationCenter.default
        isEditingState = .init(value: false)
        loginStateDidChangedEvent = notificationCenter.rx.notification(.loginStateDidChanged).asObservable()
    }
}
