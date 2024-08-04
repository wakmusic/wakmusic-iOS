import Foundation
import RxSwift

public struct UpdateNotificationTokenUseCaseSpy: UpdateNotificationTokenUseCase {
    public func execute(type: NotificationUpdateType) -> Completable {
        Completable.create { observer in
            observer(.completed)
            return Disposables.create()
        }
    }

    public init() {}
}
