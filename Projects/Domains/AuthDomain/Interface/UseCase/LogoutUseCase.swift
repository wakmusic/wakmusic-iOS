import RxSwift

public protocol LogoutUseCase: Sendable {
    func execute(localOnly: Bool) -> Completable
}
