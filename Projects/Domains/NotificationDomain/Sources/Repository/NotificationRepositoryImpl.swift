import NotificationDomainInterface
import RxSwift

public final class NotificationRepositoryImpl: NotificationRepository {
    private let remoteNotificationDataSource: any RemoteNotificationDataSource

    public init(
        remoteNotificationDataSource: RemoteNotificationDataSource
    ) {
        self.remoteNotificationDataSource = remoteNotificationDataSource
    }

    public func updateNotificationToken(type: NotificationUpdateType) -> Completable {
        remoteNotificationDataSource.updateNotificationToken(type: type)
    }
}
