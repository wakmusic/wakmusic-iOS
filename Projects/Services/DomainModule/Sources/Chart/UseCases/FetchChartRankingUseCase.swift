import Combine
import DataMappingModule
import ErrorModule
import RxSwift

public protocol FetchChartRankingUseCase {
    func execute(type: ChartDateType, limit: Int) -> Single<[SongEntity]>
}
