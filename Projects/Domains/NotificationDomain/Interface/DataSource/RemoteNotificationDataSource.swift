import Foundation
import RxSwift

public protocol RemoteNotificationDataSource {
    func updateNotificationToken(type: NotificationUpdateType) -> Completable
}
