import BaseFeature
import ChartDomain
import ChartDomainInterface
import ChartFeature
import ChartFeatureInterface
@preconcurrency import NeedleFoundation

public extension AppComponent {
    var chartFactory: any ChartFactory {
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
