import Foundation
import RxSwift
import Utility

protocol StorageCommonService {
    var isEditingState: BehaviorSubject<Bool> { get }
    var loginStateDidChangedEvent: Observable<Notification> { get }
    var playlistRefreshEvent: Observable<Notification> { get }
}

final class DefaultStorageCommonService: StorageCommonService {
    let isEditingState: BehaviorSubject<Bool>
    let loginStateDidChangedEvent: Observable<Notification>
    let playlistRefreshEvent: Observable<Notification>
    
    init() {
        let notificationCenter = NotificationCenter.default
        isEditingState = .init(value: false)
        loginStateDidChangedEvent = notificationCenter.rx.notification(.loginStateDidChanged).asObservable()
        playlistRefreshEvent = notificationCenter.rx.notification(.playlistRefresh)
    }
}
