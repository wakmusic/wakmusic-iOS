import Foundation
import RxSwift

public protocol FetchTokenUseCase: Sendable {
    func execute(providerType: ProviderType, token: String) -> Single<AuthLoginEntity>
}
