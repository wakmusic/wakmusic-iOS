import AuthDomainInterface
import RxSwift

public struct FetchTokenUseCaseSpy: FetchTokenUseCase {
    public init() {}
    public func execute(token: String, type: ProviderType) -> Single<AuthLoginEntity> {
        return .just(AuthLoginEntity(token: ""))
    }
}
