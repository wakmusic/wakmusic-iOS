import ArtistDomainInterface
import RxSwift

public final class FindArtistIDUseCaseSpy: FindArtistIDUseCase, @unchecked Sendable {
    public private(set) var callCount = 0
    public var handler: ((String) -> Single<String>) = { _ in .never() }
    public func execute(name: String) -> Single<String> {
        callCount += 1
        return handler(name)
    }
}
