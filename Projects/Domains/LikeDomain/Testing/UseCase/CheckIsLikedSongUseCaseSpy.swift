import LikeDomainInterface
import RxSwift

public final class CheckIsLikedSongUseCaseSpy: CheckIsLikedSongUseCase {
    public private(set) var callCount = 0
    public var handler: (String) -> Single<Bool> = { _ in fatalError() }

    public init() {}

    public func execute(id: String) -> Single<Bool> {
        callCount += 1
        return handler(id)
    }
}