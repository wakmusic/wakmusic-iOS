import ArtistFeature
import BaseFeature
import Foundation
import HomeFeature
import MyInfoFeature
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import SearchFeature
import SearchFeatureInterface
import StorageFeature
import StorageFeatureInterface

public protocol MainTabBarDependency: Dependency {
    var fetchNoticePopupUseCase: any FetchNoticePopupUseCase { get }
    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase { get }
    var homeComponent: HomeComponent { get }
    var searchFactory: any SearchFactory { get }
    var artistComponent: ArtistComponent { get }
    var storageFactory: any StorageFactory { get }
    var myInfoFactory: any MyInfoFactory { get }
    var noticePopupComponent: NoticePopupComponent { get }
    var noticeFactory: any NoticeFactory { get }
    var noticeDetailFactory: any NoticeDetailFactory { get }
}

public final class MainTabBarComponent: Component<MainTabBarDependency> {
    public func makeView() -> MainTabBarViewController {
        return MainTabBarViewController.viewController(
            viewModel: MainTabBarViewModel.init(
                fetchNoticePopupUseCase: self.dependency.fetchNoticePopupUseCase,
                fetchNoticeIDListUseCase: self.dependency.fetchNoticeIDListUseCase
            ),
            homeComponent: self.dependency.homeComponent,
            searchFactory: self.dependency.searchFactory,
            artistComponent: self.dependency.artistComponent,
            storageFactory: self.dependency.storageFactory,
            myInfoFactory: self.dependency.myInfoFactory,
            noticePopupComponent: self.dependency.noticePopupComponent,
            noticeFactory: self.dependency.noticeFactory,
            noticeDetailFactory: self.dependency.noticeDetailFactory
        )
    }
}
