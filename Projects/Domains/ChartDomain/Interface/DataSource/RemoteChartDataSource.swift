import Foundation
import RxSwift

public protocol RemoteChartDataSource: Sendable {
    func fetchChartRanking(type: ChartDateType) -> Single<ChartEntity>
    func fetchCurrentVideoUseCase() -> Single<CurrentVideoEntity>
}
