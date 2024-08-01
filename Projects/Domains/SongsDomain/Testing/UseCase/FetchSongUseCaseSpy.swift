import RxSwift
import SongsDomainInterface

public final class FetchSongUseCaseSpy: FetchSongUseCase {
    public private(set) var callCount = 0
    public var handler: ((String) -> Single<SongDetailEntity>) = { _ in fatalError() }

    public init() {}

    public func execute(id: String) -> Single<SongDetailEntity> {
        callCount += 1
        return handler(id)
    }
}
