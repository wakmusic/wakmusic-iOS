import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchChartRankingUseCaseImpl: FetchChartRankingUseCase {
    private let chartRepository: any ChartRepository

    public init(
        chartRepository: ChartRepository
    ) {
        self.chartRepository = chartRepository
    }

    public func execute(type: ChartDateType, limit: Int) -> Single<[ChartRankingEntity]> {
        chartRepository.fetchChartRanking(type: type, limit: limit)
    }
}
