import Foundation
import RxSwift

public protocol FetchChartRankingUseCase: Sendable {
    func execute(type: ChartDateType) -> Single<ChartEntity>
}
