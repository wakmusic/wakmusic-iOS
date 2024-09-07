import AuthDomainInterface
import Foundation
import RxSwift
import Utility

public struct FetchTokenUseCaseImpl: FetchTokenUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute(providerType: ProviderType, token: String) -> Single<AuthLoginEntity> {
        authRepository.fetchToken(providerType: providerType, token: token)
    }
}
