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
    
    public func fetchChartUpdateTime(type: ChartDateType) -> Single<String> {
        remoteChartDataSource.fetchChartUpdateTime(type: type)
            .map {
                let convert: TimeInterval = TimeInterval($0) ?? -1
                return convert == -1 ?
                    $0 : Date(timeIntervalSince1970: convert).changeDateFormatForChart() + " 업데이트"
            }
    }
}
