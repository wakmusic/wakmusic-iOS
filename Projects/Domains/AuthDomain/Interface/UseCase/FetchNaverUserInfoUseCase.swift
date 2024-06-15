import Foundation
import RxSwift

@available(*, deprecated, message: "구현체를 사용하는 곳이 없음")
public protocol FetchNaverUserInfoUseCase {
    func execute(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity>
}
