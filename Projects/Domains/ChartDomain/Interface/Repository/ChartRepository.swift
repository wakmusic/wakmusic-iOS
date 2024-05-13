import Foundation
import RxSwift

public protocol ChartRepository {
    func fetchChartRanking(type: ChartDateType) -> Single<[ChartRankingEntity]>
    func fetchChartUpdateTime(type: ChartDateType) -> Single<String>
}
