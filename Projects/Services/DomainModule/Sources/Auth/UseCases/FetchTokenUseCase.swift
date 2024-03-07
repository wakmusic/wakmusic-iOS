import DataMappingModule
import Foundation
import RxSwift

public protocol FetchTokenUseCase {
    func execute(token: String, type: ProviderType) -> Single<AuthLoginEntity>
}
