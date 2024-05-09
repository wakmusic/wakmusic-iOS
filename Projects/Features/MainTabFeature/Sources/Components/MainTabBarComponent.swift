import ArtistFeature
import BaseFeature
import ChartFeature
import Foundation
import HomeFeature
import MyInfoFeature
import NeedleFoundation
import NoticeDomainInterface
import SearchFeature
import StorageFeature
import StorageFeatureInterface

public protocol MainTabBarDependency: Dependency {
    var fetchNoticeUseCase: any FetchNoticeUseCase { get }
    var homeComponent: HomeComponent { get }
    var chartComponent: ChartComponent { get }
    var searchComponent: SearchComponent { get }
    var artistComponent: ArtistComponent { get }
    var storageFactory: any StorageFactory { get }
    var myInfoComponent: MyInfoComponent { get }
    var noticePopupComponent: NoticePopupComponent { get }
    var noticeComponent: NoticeComponent { get }
    var noticeDetailComponent: NoticeDetailComponent { get }
}

public final class MainTabBarComponent: Component<MainTabBarDependency> {
    public func makeView() -> MainTabBarViewController {
        return MainTabBarViewController.viewController(
            viewModel: MainTabBarViewModel.init(
                fetchNoticeUseCase: self.dependency.fetchNoticeUseCase
            ),
            homeComponent: self.dependency.homeComponent,
            chartComponent: self.dependency.chartComponent,
            searchComponent: self.dependency.searchComponent,
            artistComponent: self.dependency.artistComponent,
            storageFactory: self.dependency.storageFactory,
            myInfoComponent: self.dependency.myInfoComponent,
            noticePopupComponent: self.dependency.noticePopupComponent,
            noticeComponent: self.dependency.noticeComponent,
            noticeDetailComponent: self.dependency.noticeDetailComponent
        )
    }
}
