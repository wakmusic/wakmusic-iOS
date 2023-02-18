import DomainModule
import DataModule
import NetworkModule
import ChartFeature
import CommonFeature

public extension AppComponent {
    var chartComponent: ChartComponent {
        ChartComponent(parent: self)
    }

    var remoteChartDataSource: any RemoteChartDataSource {
        shared {
            RemoteChartDataSourceImpl(keychain: keychain)
        }
    }

    var chartRepository: any ChartRepository {
        shared {
            ChartRepositoryImpl(remoteChartDataSource: remoteChartDataSource)
        }
    }

    var fetchChartRankingUseCase: any FetchChartRankingUseCase {
        shared {
            FetchChartRankingUseCaseImpl(chartRepository: chartRepository)
        }
    }

    var fetchChartUpdateTimeUseCase: any FetchChartUpdateTimeUseCase {
        shared {
            FetchChartUpdateTimeUseCaseImpl(chartRepository: chartRepository)
        }
    }
}
