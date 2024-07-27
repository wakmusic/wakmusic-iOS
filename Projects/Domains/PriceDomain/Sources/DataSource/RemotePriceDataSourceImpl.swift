import BaseDomain
import Foundation
import RxSwift
import PriceDomainInterface

public final class RemotePriceDataSourceImpl: BaseRemoteDataSource<PriceAPI>, RemotePriceDataSource {
  
    public func fetchPlaylistCreationPrice() -> Single<PriceEntity> {
        request(.fetchPlaylistCreationPrice)
            .map(PriceResponseDTO.self)
            .map({ $0.toDomain() })
    }
    
    public func fetchPlaylistImagePrice() -> Single<PriceEntity> {
        request(.fetchPlaylistImagePrice)
            .map(PriceResponseDTO.self)
            .map({ $0.toDomain() })
        
    }
}
