import Foundation
import RxSwift

public protocol NotificationRepository {
    func updateNotificationToken(type: NotificationUpdateType) -> Completable
}
