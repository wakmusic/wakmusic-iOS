import Foundation
import RxSwift

public protocol ChartRepository: Sendable {
    func fetchChartRanking(type: ChartDateType) -> Single<ChartEntity>
    func fetchCurrentVideoUseCase() -> Single<CurrentVideoEntity>
}
