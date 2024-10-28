import ArtistDomainInterface
import RxSwift

public final class FindArtistIDUseCaseSpy: FindArtistIDUseCase {
    public private(set) var callCount = 0
    public var handler: (() -> Single<String>) = { .never() }
    public func execute(name: String) -> Single<String> {
        callCount += 1
        return handler()
    }
}
