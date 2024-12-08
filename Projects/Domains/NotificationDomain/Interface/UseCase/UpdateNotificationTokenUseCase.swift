import Foundation
import RxSwift

public protocol UpdateNotificationTokenUseCase: Sendable {
    func execute(type: NotificationUpdateType) -> Completable
}
