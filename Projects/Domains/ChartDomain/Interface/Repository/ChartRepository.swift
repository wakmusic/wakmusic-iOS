import Foundation
import RxSwift

public protocol ChartRepository {
    func fetchChartRanking(type: ChartDateType, limit: Int) -> Single<[ChartRankingEntity]>
    func fetchChartUpdateTime(type: ChartDateType) -> Single<String>
}
