import AuthDomainInterface
import RxSwift

public struct CheckIsExistAccessTokenUseCaseStub: CheckIsExistAccessTokenUseCase {
    public func execute() -> Single<Bool> {
        return .just(false)
    }
}
