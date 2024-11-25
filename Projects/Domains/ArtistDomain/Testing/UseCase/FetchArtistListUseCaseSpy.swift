import ArtistDomainInterface
import Foundation
import RxSwift

public final class FetchArtistListUseCaseSpy: FetchArtistListUseCase, @unchecked Sendable {
    public private(set) var callCount = 0
    public var handler: (() -> Single<[ArtistEntity]>) = { .never() }
    public func execute() -> Single<[ArtistEntity]> {
        callCount += 1
        return handler()
    }
}
