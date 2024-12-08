import Foundation
import RxSwift

public protocol RemoteNotificationDataSource: Sendable {
    func updateNotificationToken(type: NotificationUpdateType) -> Completable
}
