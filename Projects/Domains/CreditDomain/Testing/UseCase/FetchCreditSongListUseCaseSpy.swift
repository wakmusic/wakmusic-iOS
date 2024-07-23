import CreditDomainInterface
import RxSwift
import SongsDomainInterface

public final class FetchCreditSongListUseCaseSpy: FetchCreditSongListUseCase {
    public var callCount = 0
    public var handler: (String, CreditSongOrderType, Int, Int) -> Single<[SongEntity]> = { _, _, _, _ in fatalError() }

    public init() {}

    public func execute(
        name: String,
        order: CreditSongOrderType,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]> {
        callCount += 1
        return handler(name, order, page, limit)
    }
}
