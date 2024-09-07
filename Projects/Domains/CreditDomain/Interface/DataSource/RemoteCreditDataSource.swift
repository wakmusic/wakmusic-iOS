import Foundation
import RxSwift
import SongsDomainInterface

public protocol RemoteCreditDataSource {
    func fetchCreditSongList(
        name: String,
        order: CreditSongOrderType,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]>

    func fetchCreditProfile(name: String) -> Single<CreditProfileEntity>
}
