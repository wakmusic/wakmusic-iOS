import ArtistFeature
import BaseFeature
import Foundation
import HomeFeature
import MyInfoFeature
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import PlaylistFeatureInterface
import SearchFeature
import SearchFeatureInterface
import StorageFeature
import StorageFeatureInterface

public protocol MainTabBarDependency: Dependency {
    var fetchNoticePopupUseCase: any FetchNoticePopupUseCase { get }
    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase { get }
    var appEntryState: any AppEntryStateHandleable { get }
    var homeComponent: HomeComponent { get }
    var searchFactory: any SearchFactory { get }
    var artistComponent: ArtistComponent { get }
    var storageFactory: any StorageFactory { get }
    var myInfoFactory: any MyInfoFactory { get }
    var noticePopupComponent: NoticePopupComponent { get }
    var noticeDetailFactory: any NoticeDetailFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
}

public final class MainTabBarComponent: Component<MainTabBarDependency> {
    public func makeView() -> MainTabBarViewController {
        return MainTabBarViewController.viewController(
            viewModel: MainTabBarViewModel.init(
                fetchNoticePopupUseCase: dependency.fetchNoticePopupUseCase,
                fetchNoticeIDListUseCase: dependency.fetchNoticeIDListUseCase
            ),
            appEntryState: dependency.appEntryState,
            homeComponent: dependency.homeComponent,
            searchFactory: dependency.searchFactory,
            artistComponent: dependency.artistComponent,
            storageFactory: dependency.storageFactory,
            myInfoFactory: dependency.myInfoFactory,
            noticePopupComponent: dependency.noticePopupComponent,
            noticeDetailFactory: dependency.noticeDetailFactory,
            playlistDetailFactory: dependency.playlistDetailFactory
        )
    }
}
