import AuthDomainInterface
import RxSwift

public struct LogoutUseCaseSpy: LogoutUseCase {
    public func execute(localOnly: Bool) -> Completable {
        Completable.create { observer in
            observer(.completed)
            return Disposables.create()
        }
    }
}
