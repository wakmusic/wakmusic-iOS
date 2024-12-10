import Foundation
import RxSwift
import Utility

protocol MyInfoCommonService {
    var willRefreshUserInfoEvent: Observable<Notification> { get }
    var didChangedUserInfoEvent: Observable<UserInfo?> { get }
    var didChangedReadNoticeIDsEvent: Observable<[Int]?> { get }
}

final class DefaultMyInfoCommonService: MyInfoCommonService {
    let willRefreshUserInfoEvent: Observable<Notification>
    let didChangedUserInfoEvent: Observable<UserInfo?>
    let didChangedReadNoticeIDsEvent: Observable<[Int]?>

    nonisolated(unsafe) static let shared = DefaultMyInfoCommonService()

    init() {
        let notificationCenter = NotificationCenter.default
        willRefreshUserInfoEvent = notificationCenter.rx.notification(.willRefreshUserInfo)
        didChangedUserInfoEvent = PreferenceManager.shared.$userInfo
        didChangedReadNoticeIDsEvent = PreferenceManager.shared.$readNoticeIDs
    }
}
