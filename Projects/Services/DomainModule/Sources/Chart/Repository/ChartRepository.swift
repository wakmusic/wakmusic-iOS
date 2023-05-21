import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol ChartRepository {
    func fetchChartRanking(type: ChartDateType, limit: Int) -> Single<[ChartRankingEntity]>
    func fetchChartUpdateTime() -> Single<String>
}
