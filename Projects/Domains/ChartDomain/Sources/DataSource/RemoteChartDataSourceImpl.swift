import BaseDomain
import ChartDomainInterface
import Foundation
import RxSwift

public final class RemoteChartDataSourceImpl: BaseRemoteDataSource<ChartAPI>, RemoteChartDataSource {
    public func fetchChartRanking(type: ChartDateType) -> Single<[ChartRankingEntity]> {
        request(.fetchChartRanking(type: type))
            .map([SingleChartRankingResponseDTO].self)
            .map { $0.map { $0.toDomain(type: type) } }
    }

    public func fetchChartUpdateTime(type: ChartDateType) -> Single<String> {
        request(.fetchChartUpdateTime(type: type))
            .map { String(data: $0.data, encoding: .utf8) ?? "" }
    }
}
