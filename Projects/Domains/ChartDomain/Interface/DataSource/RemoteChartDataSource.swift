import ErrorModule
import Foundation
import RxSwift

public protocol RemoteChartDataSource {
    func fetchChartRanking(type: ChartDateType, limit: Int) -> Single<[ChartRankingEntity]>
    func fetchChartUpdateTime(type: ChartDateType) -> Single<String>
}
