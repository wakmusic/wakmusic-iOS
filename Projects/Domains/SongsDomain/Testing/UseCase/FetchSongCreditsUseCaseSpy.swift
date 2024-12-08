import RxSwift
import SongsDomainInterface

public final class FetchSongCreditsUseCaseSpy: FetchSongCreditsUseCase, @unchecked Sendable {
    public private(set) var callCount = 0
    public var handler: ((String) -> Single<[SongCreditsEntity]>) = { _ in fatalError() }

    public init() {}

    public func execute(id: String) -> Single<[SongCreditsEntity]> {
        callCount += 1
        return handler(id)
    }
}
