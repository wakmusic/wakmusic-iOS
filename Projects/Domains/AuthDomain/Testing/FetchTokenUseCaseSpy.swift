import AuthDomainInterface
import RxSwift

public struct FetchTokenUseCaseSpy: FetchTokenUseCase {
    public func execute(providerType: ProviderType, token: String) -> Single<AuthLoginEntity> {
        return .just(AuthLoginEntity(token: ""))
    }
}
