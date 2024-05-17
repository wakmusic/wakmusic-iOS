import Foundation
import RxSwift

public protocol FetchChartRankingUseCase {
    func execute(type: ChartDateType) -> Single<ChartEntity>
}
