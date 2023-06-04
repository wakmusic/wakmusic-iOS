import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchChartUpdateTimeUseCaseImpl: FetchChartUpdateTimeUseCase {
    private let chartRepository: any ChartRepository

    public init(
        chartRepository: ChartRepository
    ) {
        self.chartRepository = chartRepository
    }

    public func execute(type: ChartDateType) -> Single<String> {
        chartRepository.fetchChartUpdateTime(type: type)
    }
}
