import RxSwift

public protocol LogoutUseCase {
    func execute() -> Completable
}
