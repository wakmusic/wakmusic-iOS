import Foundation
import RxSwift

public protocol UpdateNotificationTokenUseCase {
    func execute(type: NotificationUpdateType) -> Completable
}
