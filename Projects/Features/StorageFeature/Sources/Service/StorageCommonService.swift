import Foundation
import RxSwift
import Utility

protocol StorageCommonService {
    var isEditingState: BehaviorSubject<Bool> { get }
    var changedUserInfoEvent: Observable<UserInfo?> { get }
    var movedLikeStorageEvent: Observable<Notification> { get }
    var playlistRefreshEvent: Observable<Notification> { get }
}

final class DefaultStorageCommonService: StorageCommonService {
    let isEditingState: BehaviorSubject<Bool> = .init(value: false)
    let changedUserInfoEvent: Observable<UserInfo?> = PreferenceManager.$userInfo
    let movedLikeStorageEvent: Observable<Notification> = NotificationCenter.default.rx
        .notification(.movedStorageFavoriteTab)
    
    let playlistRefreshEvent: Observable<Notification> = NotificationCenter.default.rx.notification(.playlistRefresh)

    static let shared = DefaultStorageCommonService()
}
