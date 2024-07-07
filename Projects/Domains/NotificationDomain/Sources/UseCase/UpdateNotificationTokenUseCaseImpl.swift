import Foundation
import NotificationDomainInterface
import RxSwift

public struct UpdateNotificationTokenUseCaseImpl: UpdateNotificationTokenUseCase {
    private let notificationRepository: any NotificationRepository

    public init(
        notificationRepository: NotificationRepository
    ) {
        self.notificationRepository = notificationRepository
    }

    public func execute(type: NotificationUpdateType) -> Completable {
        notificationRepository.updateNotificationToken(type: type)
    }
}
