import RxSwift

public protocol LogoutUseCase {
    func execute(localOnly: Bool) -> Completable
}
