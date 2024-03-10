import Foundation
import RxSwift

public protocol FetchChartRankingUseCase {
    func execute(type: ChartDateType, limit: Int) -> Single<[ChartRankingEntity]>
}
