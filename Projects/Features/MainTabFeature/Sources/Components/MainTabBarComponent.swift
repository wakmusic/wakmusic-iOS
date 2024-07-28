import ArtistFeatureInterface
import BaseFeature
import Foundation
import HomeFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import PlaylistFeatureInterface
import SearchFeatureInterface
import StorageFeatureInterface

public protocol MainTabBarDependency: Dependency {
    var fetchNoticePopupUseCase: any FetchNoticePopupUseCase { get }
    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase { get }
    var appEntryState: any AppEntryStateHandleable { get }
    var homeFactory: any HomeFactory { get }
    var searchFactory: any SearchFactory { get }
    var artistFactory: any ArtistFactory { get }
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
            homeFactory: dependency.homeFactory,
            searchFactory: dependency.searchFactory,
            artistFactory: dependency.artistFactory,
            storageFactory: dependency.storageFactory,
            myInfoFactory: dependency.myInfoFactory,
            noticePopupComponent: dependency.noticePopupComponent,
            noticeDetailFactory: dependency.noticeDetailFactory,
            playlistDetailFactory: dependency.playlistDetailFactory
        )
    }
}
