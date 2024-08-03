import Foundation
import RxSwift
import Utility

protocol MyInfoCommonService {
    var willRefreshUserInfoEvent: Observable<Notification> { get }
}

final class DefaultMyInfoCommonService: MyInfoCommonService {

    let willRefreshUserInfoEvent: Observable<Notification>
    static let shared = DefaultMyInfoCommonService()

    init() {
        let notificationCenter = NotificationCenter.default
        willRefreshUserInfoEvent = notificationCenter.rx.notification(.willRefreshUserInfo)
    }
}
