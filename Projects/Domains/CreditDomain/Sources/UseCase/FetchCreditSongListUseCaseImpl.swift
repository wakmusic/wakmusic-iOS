import CreditDomainInterface
import RxSwift
import SongsDomainInterface

public final class FetchCreditSongListUseCaseImpl: FetchCreditSongListUseCase {
    public init() {}

    public func execute(
        name: String,
        order: CreditSongOrderType,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]> {
        #warning("구현")
        return .never()
    }
}
