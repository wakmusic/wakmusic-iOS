import AuthDomainInterface
import Foundation
import RxSwift

public struct ReGenerateAccessTokenUseCaseImpl: ReGenerateAccessTokenUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> Single<AuthLoginEntity> {
        authRepository.reGenerateAccessToken()
    }
}
