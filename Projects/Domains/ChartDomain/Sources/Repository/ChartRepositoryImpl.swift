import ChartDomainInterface
import Foundation
import RxSwift

public final class ChartRepositoryImpl: ChartRepository {
    private let remoteChartDataSource: any RemoteChartDataSource

    public init(
        remoteChartDataSource: RemoteChartDataSource
    ) {
        self.remoteChartDataSource = remoteChartDataSource
    }

    public func fetchChartRanking(type: ChartDateType) -> Single<ChartEntity> {
        remoteChartDataSource.fetchChartRanking(type: type)
    }

    public func fetchCurrentVideoUseCase() -> Single<CurrentVideoEntity> {
        remoteChartDataSource.fetchCurrentVideoUseCase()
    }
}
