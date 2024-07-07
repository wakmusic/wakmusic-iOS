import BaseDomain
import Foundation
import NotificationDomainInterface
import RxSwift

public final class RemoteNotificationDataSourceImpl:
    BaseRemoteDataSource<NotificationAPI>,
    RemoteNotificationDataSource {
    public func updateNotificationToken(type: NotificationUpdateType) -> Completable {
        request(.updateNotificationToken(type: type))
            .asCompletable()
    }
}
