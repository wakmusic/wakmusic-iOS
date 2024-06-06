import AuthDomainInterface
import Foundation
import RxSwift

public struct FetchNaverUserInfoUseCaseSpy: FetchNaverUserInfoUseCase {
    public init() {}
    public func execute(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity> {
        return .just(NaverUserInfoEntity(resultcode: "", message: "", id: "", nickname: ""))
    }
}
