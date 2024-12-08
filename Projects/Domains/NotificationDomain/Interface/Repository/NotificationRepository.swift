import Foundation
import RxSwift

public protocol NotificationRepository: Sendable {
    func updateNotificationToken(type: NotificationUpdateType) -> Completable
}
