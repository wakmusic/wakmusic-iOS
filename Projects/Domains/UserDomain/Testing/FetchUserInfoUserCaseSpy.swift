import Foundation
import RxSwift
import UserDomainInterface

public struct FetchUserInfoUseCaseSpy: FetchUserInfoUseCase {
    public func execute() -> Single<UserInfoEntity> {
        return .just(UserInfoEntity(id: "fakeid", platform: "naver", name: "fakename", profile: "", itemCount: 1))
    }
}
