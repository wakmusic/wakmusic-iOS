import BaseDomain
import CreditDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface

public final class RemoteCreditDataSourceImpl: BaseRemoteDataSource<CreditAPI>, RemoteCreditDataSource {
    public func fetchCreditSongList(
        name: String,
        order: CreditSongOrderType,
        page: Int,
        limit: Int
    ) -> Single<[SongEntity]> {
        request(.fetchCreditSongList(name: name, order: order, page: page, limit: limit))
            .map([FetchCreditSongListResponseDTO].self)
            .map { $0.toDomain() }
    }

    public func fetchCreditProfile(name: String) -> Single<CreditProfileEntity> {
        request(.fetchProfile(name: name))
            .map(FetchCreditProfileResponseDTO.self)
            .map { $0.toDomain() }
    }
}
