import AuthDomainInterface
import RxSwift

public struct CheckIsExistAccessTokenUseCaseImpl: CheckIsExistAccessTokenUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> Single<Bool> {
        authRepository.checkIsExistAccessToken()
    }
}
