import BaseFeature
import ChartDomain
import ChartDomainInterface
import ChartFeature

public extension AppComponent {
    var chartComponent: ChartComponent {
        ChartComponent(parent: self)
    }

    var chartContentComponent: ChartContentComponent {
        ChartContentComponent(parent: self)
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

    var fetchCurrentVideoUseCase: any FetchCurrentVideoUseCase {
        shared {
            FetchCurrentVideoUseCaseImpl(chartRepository: chartRepository)
        }
    }
}
