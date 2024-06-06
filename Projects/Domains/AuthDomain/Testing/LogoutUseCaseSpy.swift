import AuthDomainInterface
import RxSwift

public struct LogoutUseCaseSpy: LogoutUseCase {
    public init() {}
    public func execute() -> Completable {
        Completable.create { observer in
            observer(.completed)
            return Disposables.create()
        }
    }
}
