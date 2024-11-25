import NotificationDomain
import NotificationDomainInterface
@preconcurrency import NeedleFoundation

public extension AppComponent {
    var remoteNotificationDataSource: any RemoteNotificationDataSource {
        shared {
            RemoteNotificationDataSourceImpl(keychain: keychain)
        }
    }

    var notificationRepository: any NotificationRepository {
        shared {
            NotificationRepositoryImpl(remoteNotificationDataSource: remoteNotificationDataSource)
        }
    }

    var updateNotificationTokenUseCase: any UpdateNotificationTokenUseCase {
        shared {
            UpdateNotificationTokenUseCaseImpl(notificationRepository: notificationRepository)
        }
    }
}
