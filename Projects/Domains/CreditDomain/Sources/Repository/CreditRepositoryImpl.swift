import CreditDomainInterface
import ErrorModule
import RxSwift
import SongsDomainInterface

public final class CreditRepositoryImpl: CreditRepository {
    private let remoteCreditDataSource: any RemoteCreditDataSource

    public init(
        remoteCreditDataSource: any RemoteCreditDataSource
    ) {
        self.remoteCreditDataSource = remoteCreditDataSource
    }

    public func fetchCreditSongList(
        name: String,
        order: CreditSongOrderType,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]> {
        remoteCreditDataSource.fetchCreditSongList(name: name, order: order, page: page, limit: limit)
    }

    public func fetchCreditProfile(name: String) -> Single<CreditProfileEntity> {
        remoteCreditDataSource.fetchCreditProfile(name: name)
    }
}
