import Foundation
import RxSwift

public protocol ReGenerateAccessTokenUseCase: Sendable {
    func execute() -> Single<AuthLoginEntity>
}
