import Foundation
import RxSwift

public protocol ReGenerateAccessTokenUseCase {
    func execute() -> Single<AuthLoginEntity>
}
