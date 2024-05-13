import ChartDomainInterface
import Foundation
import RxSwift

public final class ChartRepositoryImpl: ChartRepository {
    private let remoteChartDataSource: any RemoteChartDataSource

    public init(
        remoteChartDataSource: RemoteChartDataSource
    ) {
        self.remoteChartDataSource = remoteChartDataSource
    }

    public func fetchChartRanking(type: ChartDateType) -> Single<[ChartRankingEntity]> {
        remoteChartDataSource.fetchChartRanking(type: type)
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
