import Foundation
import RxSwift

public protocol FetchTokenUseCase {
    func execute(providerType: ProviderType, token: String) -> Single<AuthLoginEntity>
}
