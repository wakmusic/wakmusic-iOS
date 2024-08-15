import Foundation
import RxSwift
import SongsDomainInterface

public protocol CreditRepository {
    func fetchCreditSongList(
        name: String,
        order: CreditSongOrderType,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]>

    func fetchCreditProfile(name: String) -> Single<CreditProfileEntity>
}
