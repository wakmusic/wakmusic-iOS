import Foundation
import RxSwift

public protocol ChartRepository {
    func fetchChartRanking(type: ChartDateType) -> Single<ChartEntity>
    func fetchCurrentVideoUseCase() -> Single<CurrentVideoEntity>
}
