import Foundation
import RxSwift
import Utility

protocol StorageCommonService {
    var isEditingState: BehaviorSubject<Bool> { get }
    var loginStateDidChangedEvent: Observable<String?> { get }
    var playlistRefreshEvent: Observable<Notification> { get }
}

final class DefaultStorageCommonService: StorageCommonService {
    static let shared = DefaultStorageCommonService()

    let isEditingState: BehaviorSubject<Bool>
    let loginStateDidChangedEvent: Observable<String?>
    let playlistRefreshEvent: Observable<Notification>

    init() {
        let notificationCenter = NotificationCenter.default
        isEditingState = .init(value: false)
        loginStateDidChangedEvent = PreferenceManager.$userInfo.map(\.?.ID).distinctUntilChanged().skip(1)
        playlistRefreshEvent = notificationCenter.rx.notification(.playlistRefresh)
    }
}
