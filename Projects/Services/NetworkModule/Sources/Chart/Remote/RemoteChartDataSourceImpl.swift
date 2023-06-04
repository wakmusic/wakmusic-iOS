import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public final class RemoteChartDataSourceImpl: BaseRemoteDataSource<ChartAPI>, RemoteChartDataSource {
    public func fetchChartRanking(type: ChartDateType, limit: Int) -> Single<[ChartRankingEntity]> {
        request(.fetchChartRanking(type: type, limit: limit))
            .map([SingleChartRankingResponseDTO].self)
            .map { $0.map { $0.toDomain(type: type) } }
    }
    
    public func fetchChartUpdateTime(type: ChartDateType) -> Single<String> {
        request(.fetchChartUpdateTime(type: type))
            .map { String(data: $0.data, encoding: .utf8) ?? "" }
    }
}
