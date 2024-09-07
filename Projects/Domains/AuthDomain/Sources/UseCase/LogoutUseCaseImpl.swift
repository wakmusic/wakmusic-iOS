import AuthDomainInterface
import BaseDomainInterface
import Foundation
import RxSwift
import Utility

public struct LogoutUseCaseImpl: LogoutUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute(localOnly: Bool) -> Completable {
        authRepository.logout(localOnly: localOnly)
    }
}
