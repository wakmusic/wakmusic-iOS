import ChartDomainInterface
import RxSwift

public struct FetchCurrentVideoUseCaseImpl: FetchCurrentVideoUseCase {
    private let chartRepository: any ChartRepository

    public init(
        chartRepository: ChartRepository
    ) {
        self.chartRepository = chartRepository
    }

    public func execute() -> Single<CurrentVideoEntity> {
        chartRepository.fetchCurrentVideoUseCase()
    }
}
