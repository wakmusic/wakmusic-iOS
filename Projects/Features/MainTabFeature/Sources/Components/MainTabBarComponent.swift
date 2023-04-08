import Foundation
import HomeFeature
import StorageFeature
import SearchFeature
import ArtistFeature
import ChartFeature
import CommonFeature
import NeedleFoundation
import DomainModule

public protocol MainTabBarDependency: Dependency {
    var fetchNoticeUseCase: any FetchNoticeUseCase {get}
    var homeComponent: HomeComponent { get }
    var chartComponent: ChartComponent { get }
    var searchComponent: SearchComponent { get }
    var artistComponent: ArtistComponent { get }
    var storageComponent: StorageComponent { get }
    var noticePopupComponent: NoticePopupComponent { get }
    var noticeComponent: NoticeComponent { get }
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
            storageCompoent: self.dependency.storageComponent,
            noticePopupComponent: self.dependency.noticePopupComponent,
            noticeComponent: self.dependency.noticeComponent
        )
    }
}
