import BaseDomain
import ChartDomainInterface
import Foundation
import RxSwift

public final class RemoteChartDataSourceImpl: BaseRemoteDataSource<ChartAPI>, RemoteChartDataSource {
    public func fetchChartRanking(type: ChartDateType) -> Single<ChartEntity> {
        request(.fetchChartRanking(type: type))
            .map(SingleChartRankingResponseDTO.self)
            .map { $0.toDomain(type: type) }
    }

    public func fetchCurrentVideoUseCase() -> Single<CurrentVideoEntity> {
        request(.fetchCurrentVideo)
            .map(CurrentVideoDTO.self)
            .map { $0.toDomain() }
    }
}
