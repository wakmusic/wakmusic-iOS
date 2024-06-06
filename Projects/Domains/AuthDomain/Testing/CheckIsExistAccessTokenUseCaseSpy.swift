import AuthDomainInterface
import RxSwift

public struct CheckIsExistAccessTokenUseCaseSpy: CheckIsExistAccessTokenUseCase {
    public func execute() -> Single<Bool> {
        return .just(false)
    }
}
