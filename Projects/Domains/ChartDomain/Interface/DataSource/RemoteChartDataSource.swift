import Foundation
import RxSwift

public protocol RemoteChartDataSource {
    func fetchChartRanking(type: ChartDateType) -> Single<[ChartRankingEntity]>
    func fetchChartUpdateTime(type: ChartDateType) -> Single<String>
}
