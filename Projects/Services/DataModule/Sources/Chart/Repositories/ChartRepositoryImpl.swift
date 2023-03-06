import DataMappingModule
import Foundation
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct ChartRepositoryImpl: ChartRepository {
    private let remoteChartDataSource: any RemoteChartDataSource

    public init(
        remoteChartDataSource: RemoteChartDataSource
    ) {
        self.remoteChartDataSource = remoteChartDataSource
    }
    
    public func fetchChartRanking(
        type: ChartDateType,
        limit: Int
    ) -> Single<[ChartRankingEntity]> {
        remoteChartDataSource.fetchChartRanking(type: type, limit: limit)
    }
    
    public func fetchChartUpdateTime() -> Single<String> {
        remoteChartDataSource.fetchChartUpdateTime()
            .map { TimeInterval($0) }
            .map { Date(timeIntervalSince1970: $0 ?? 0).changeDateFormatForChart() + " 업데이트" }
    }
}
