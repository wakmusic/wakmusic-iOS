import Foundation
import RxSwift

public protocol RemoteChartDataSource {
    func fetchChartRanking(type: ChartDateType) -> Single<ChartEntity>
}
