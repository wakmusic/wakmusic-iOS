import LikeDomainInterface
import RxSwift

public final class AddLikeSongUseCaseSpy: AddLikeSongUseCase, @unchecked Sendable {
    public private(set) var callCount = 0
    public var handler: (String) -> Single<LikeEntity> = { _ in fatalError() }

    public init() {}

    public func execute(id: String) -> Single<LikeEntity> {
        callCount += 1
        return handler(id)
    }
}
