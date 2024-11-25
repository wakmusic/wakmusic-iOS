import AuthDomainInterface
import RxSwift

public struct CheckIsExistAccessTokenUseCaseStub: CheckIsExistAccessTokenUseCase, @unchecked Sendable {
    public func execute() -> Single<Bool> {
        return .just(false)
    }
}
