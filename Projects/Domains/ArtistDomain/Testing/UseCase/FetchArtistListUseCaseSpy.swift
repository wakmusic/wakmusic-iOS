import ArtistDomainInterface
import Foundation
import RxSwift

public final class FetchArtistListUseCaseSpy: FetchArtistListUseCase {
    public private(set) var callCount = 0
    public var handler: (() -> Single<[ArtistListEntity]>) = { .never() }
    public func execute() -> Single<[ArtistListEntity]> {
        callCount += 1
        return handler()
    }
}
