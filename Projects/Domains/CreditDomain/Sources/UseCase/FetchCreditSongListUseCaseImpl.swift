import CreditDomainInterface
import RxSwift
import SongsDomainInterface

public final class FetchCreditSongListUseCaseImpl: FetchCreditSongListUseCase {
    private let creditRepository: any CreditRepository

    public init(
        creditRepository: any CreditRepository
    ) {
        self.creditRepository = creditRepository
    }

    public func execute(
        name: String,
        order: CreditSongOrderType,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]> {
        creditRepository.fetchCreditSongList(name: name, order: order, page: page, limit: limit)
    }
}
