import AuthDomainInterface
import BaseDomainInterface
import RxSwift
import Utility
import Foundation

public struct LogoutUseCaseImpl: LogoutUseCase {
    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func execute() -> Completable {
        authRepository.logout()
            .do(onCompleted: {
                NotificationCenter.default.post(name: .loginStateDidChanged, object: false)
            })
    }
}
