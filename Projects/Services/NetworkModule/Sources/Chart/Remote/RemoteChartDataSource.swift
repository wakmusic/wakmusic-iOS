import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteChartDataSource {
    func fetchChartRanking(type: ChartDateType, limit: Int) -> Single<[SongEntity]>
    func fetchChartUpdateTime() -> Single<String>
}
