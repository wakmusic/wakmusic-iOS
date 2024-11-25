

import AppDomain
import AppDomainInterface
import ArtistDomain
import ArtistDomainInterface
import ArtistFeature
import ArtistFeatureInterface
import AuthDomain
import AuthDomainInterface
import BaseDomainInterface
import BaseFeature
import BaseFeatureInterface
import ChartDomain
import ChartDomainInterface
import ChartFeature
import ChartFeatureInterface
import CreditDomain
import CreditDomainInterface
import CreditSongListFeature
import CreditSongListFeatureInterface
import FaqDomain
import FaqDomainInterface
import Foundation
import FruitDrawFeature
import FruitDrawFeatureInterface
import HomeFeature
import HomeFeatureInterface
import ImageDomain
import ImageDomainInterface
import KeychainModule
import LikeDomain
import LikeDomainInterface
import LyricHighlightingFeature
import LyricHighlightingFeatureInterface
import MainTabFeature
import MusicDetailFeature
import MusicDetailFeatureInterface
import MyInfoFeature
import MyInfoFeatureInterface
@preconcurrency import NeedleFoundation
import NoticeDomain
import NoticeDomainInterface
import NotificationDomain
import NotificationDomainInterface
import PlaylistDomain
import PlaylistDomainInterface
import PlaylistFeature
import PlaylistFeatureInterface
import PriceDomain
import PriceDomainInterface
import RootFeature
import SearchDomain
import SearchDomainInterface
import SearchFeature
import SearchFeatureInterface
import SignInFeature
import SignInFeatureInterface
import SongCreditFeature
import SongCreditFeatureInterface
import SongsDomain
import SongsDomainInterface
import StorageFeature
import StorageFeatureInterface
import TeamDomain
import TeamDomainInterface
import TeamFeature
import TeamFeatureInterface
import UIKit
import UserDomain
import UserDomainInterface

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

@MainActor private class ArtistDependency132a213bf62ad60c622cProvider: @preconcurrency ArtistDependency {
    var fetchArtistListUseCase: any FetchArtistListUseCase {
        return appComponent.fetchArtistListUseCase
    }
    var artistDetailFactory: any ArtistDetailFactory {
        return appComponent.artistDetailFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistComponent
@MainActor private func factorye0c5444f5894148bdd93f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistDependency132a213bf62ad60c622cProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ArtistDetailDependencyee413dcf7a70e89df6d9Provider: @preconcurrency ArtistDetailDependency {
    var artistMusicComponent: ArtistMusicComponent {
        return appComponent.artistMusicComponent
    }
    var fetchArtistDetailUseCase: any FetchArtistDetailUseCase {
        return appComponent.fetchArtistDetailUseCase
    }
    var fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase {
        return appComponent.fetchArtistSubscriptionStatusUseCase
    }
    var subscriptionArtistUseCase: any SubscriptionArtistUseCase {
        return appComponent.subscriptionArtistUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistDetailComponent
@MainActor private func factory35314797fadaf164ece6f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistDetailDependencyee413dcf7a70e89df6d9Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ArtistMusicContentDependency1615ac8469e54ec51921Provider: @preconcurrency ArtistMusicContentDependency {
    var fetchArtistSongListUseCase: any FetchArtistSongListUseCase {
        return appComponent.fetchArtistSongListUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistMusicContentComponent
@MainActor private func factory8b6ffa46033e2529b5daf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistMusicContentDependency1615ac8469e54ec51921Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ArtistMusicDependencya0f5073287829dfbc260Provider: @preconcurrency ArtistMusicDependency {
    var artistMusicContentComponent: ArtistMusicContentComponent {
        return appComponent.artistMusicContentComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistMusicComponent
@MainActor private func factory382e7f8466df35a3f1d9f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistMusicDependencya0f5073287829dfbc260Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class LyricHighlightingDependency47c68b56cdde819901d2Provider: @preconcurrency LyricHighlightingDependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase {
        return appComponent.fetchLyricsUseCase
    }
    var lyricDecoratingComponent: LyricDecoratingComponent {
        return appComponent.lyricDecoratingComponent
    }
    var lyricHighlightingFactory: any LyricHighlightingFactory {
        return appComponent.lyricHighlightingFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->LyricHighlightingComponent
@MainActor private func factory57ee59e468bef412b173f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LyricHighlightingDependency47c68b56cdde819901d2Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class LyricDecoratingDependencya7e8bf6f2f4ae447ba4eProvider: @preconcurrency LyricDecoratingDependency {
    var fetchLyricDecoratingBackgroundUseCase: any FetchLyricDecoratingBackgroundUseCase {
        return appComponent.fetchLyricDecoratingBackgroundUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->LyricDecoratingComponent
@MainActor private func factory5d05db9eb4337d682097f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LyricDecoratingDependencya7e8bf6f2f4ae447ba4eProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class MainTabBarDependencycd05b79389a6a7a6c20fProvider: @preconcurrency MainTabBarDependency {
    var fetchNoticePopupUseCase: any FetchNoticePopupUseCase {
        return appComponent.fetchNoticePopupUseCase
    }
    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase {
        return appComponent.fetchNoticeIDListUseCase
    }
    var updateNotificationTokenUseCase: any UpdateNotificationTokenUseCase {
        return appComponent.updateNotificationTokenUseCase
    }
    var fetchSongUseCase: any FetchSongUseCase {
        return appComponent.fetchSongUseCase
    }
    var appEntryState: any AppEntryStateHandleable {
        return appComponent.appEntryState
    }
    var homeFactory: any HomeFactory {
        return appComponent.homeFactory
    }
    var searchFactory: any SearchFactory {
        return appComponent.searchFactory
    }
    var artistFactory: any ArtistFactory {
        return appComponent.artistFactory
    }
    var storageFactory: any StorageFactory {
        return appComponent.storageFactory
    }
    var myInfoFactory: any MyInfoFactory {
        return appComponent.myInfoFactory
    }
    var noticePopupComponent: NoticePopupComponent {
        return appComponent.noticePopupComponent
    }
    var noticeDetailFactory: any NoticeDetailFactory {
        return appComponent.noticeDetailFactory
    }
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    var musicDetailFactory: any MusicDetailFactory {
        return appComponent.musicDetailFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MainTabBarComponent
@MainActor private func factorye547a52b3fce5887c8c7f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainTabBarDependencycd05b79389a6a7a6c20fProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class BottomTabBarDependency237c2bd1c7be62020295Provider: @preconcurrency BottomTabBarDependency {


    init() {

    }
}
/// ^->AppComponent->BottomTabBarComponent
@MainActor private func factoryd34fa9e493604a6295bde3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return BottomTabBarDependency237c2bd1c7be62020295Provider()
}
@MainActor private class MainContainerDependencyd9d908a1d0cf8937bbadProvider: @preconcurrency MainContainerDependency {
    var bottomTabBarComponent: BottomTabBarComponent {
        return appComponent.bottomTabBarComponent
    }
    var mainTabBarComponent: MainTabBarComponent {
        return appComponent.mainTabBarComponent
    }
    var playlistFactory: any PlaylistFactory {
        return appComponent.playlistFactory
    }
    var playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol {
        return appComponent.playlistPresenterGlobalState
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MainContainerComponent
@MainActor private func factory8e19f48d5d573d3ea539f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainContainerDependencyd9d908a1d0cf8937bbadProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class NoticePopupDependency579e3504f53119c2eef1Provider: @preconcurrency NoticePopupDependency {


    init() {

    }
}
/// ^->AppComponent->NoticePopupComponent
@MainActor private func factorycd081aacb61d6a707ca7e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NoticePopupDependency579e3504f53119c2eef1Provider()
}
@MainActor private class PlaylistCoverOptionPopupDependencydda632c1d493aaca2ef1Provider: @preconcurrency PlaylistCoverOptionPopupDependency {
    var fetchPlaylistImagePriceUseCase: any FetchPlaylistImagePriceUseCase {
        return appComponent.fetchPlaylistImagePriceUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->PlaylistCoverOptionPopupComponent
@MainActor private func factory487946b77daee32980aff47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlaylistCoverOptionPopupDependencydda632c1d493aaca2ef1Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class PlaylistDetailFactoryDependencyad39fd621b86af45813fProvider: @preconcurrency PlaylistDetailFactoryDependency {
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory {
        return appComponent.myPlaylistDetailFactory
    }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory {
        return appComponent.unknownPlaylistDetailFactory
    }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory {
        return appComponent.wakmusicPlaylistDetailFactory
    }
    var requestPlaylistOwnerIDUsecase: any RequestPlaylistOwnerIDUsecase {
        return appComponent.requestPlaylistOwnerIDUsecase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->PlaylistDetailComponent
@MainActor private func factory6595408565b754d9f0f7f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlaylistDetailFactoryDependencyad39fd621b86af45813fProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class WakmusicPlaylistDetailDependencyaf7bde55d9c36b36ed3cProvider: @preconcurrency WakmusicPlaylistDetailDependency {
    var fetchWMPlaylistDetailUseCase: any FetchWMPlaylistDetailUseCase {
        return appComponent.fetchWMPlaylistDetailUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->WakmusicPlaylistDetailComponent
@MainActor private func factorye3e053cabf65749566c8f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return WakmusicPlaylistDetailDependencyaf7bde55d9c36b36ed3cProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class MyPlaylistDetailDependency69ff6bac42b1db843b34Provider: @preconcurrency MyPlaylistDetailDependency {
    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase {
        return appComponent.fetchPlaylistDetailUseCase
    }
    var updatePlaylistUseCase: any UpdatePlaylistUseCase {
        return appComponent.updatePlaylistUseCase
    }
    var updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase {
        return appComponent.updateTitleAndPrivateUseCase
    }
    var removeSongsUseCase: any RemoveSongsUseCase {
        return appComponent.removeSongsUseCase
    }
    var uploadDefaultPlaylistImageUseCase: any UploadDefaultPlaylistImageUseCase {
        return appComponent.uploadDefaultPlaylistImageUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var multiPurposePopupFactory: any MultiPurposePopupFactory {
        return appComponent.multiPurposePopupFactory
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var playlistCoverOptionPopupFactory: any PlaylistCoverOptionPopupFactory {
        return appComponent.playlistCoverOptionPopupFactory
    }
    var checkPlaylistCoverFactory: any CheckPlaylistCoverFactory {
        return appComponent.checkPlaylistCoverFactory
    }
    var defaultPlaylistCoverFactory: any DefaultPlaylistCoverFactory {
        return appComponent.defaultPlaylistCoverFactory
    }
    var requestCustomImageURLUseCase: any RequestCustomImageURLUseCase {
        return appComponent.requestCustomImageURLUseCase
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MyPlaylistDetailComponent
@MainActor private func factoryc6efd92ea498eaae7ff8f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MyPlaylistDetailDependency69ff6bac42b1db843b34Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class DefaultPlaylistCoverDependency47d3a4d69f35b248b60dProvider: @preconcurrency DefaultPlaylistCoverDependency {
    var fetchDefaultPlaylistImageUseCase: any FetchDefaultPlaylistImageUseCase {
        return appComponent.fetchDefaultPlaylistImageUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->DefaultPlaylistCoverComponent
@MainActor private func factory89371387a9e4c131e13df47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return DefaultPlaylistCoverDependency47d3a4d69f35b248b60dProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class PlaylistDependency6f376d117dc0f38671edProvider: @preconcurrency PlaylistDependency {
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->PlaylistComponent
@MainActor private func factory3a0a6eb1061d8d5a2deff47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlaylistDependency6f376d117dc0f38671edProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class UnknownPlaylistDetailDependency7288879231117fbf1b1bProvider: @preconcurrency UnknownPlaylistDetailDependency {
    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase {
        return appComponent.fetchPlaylistDetailUseCase
    }
    var subscribePlaylistUseCase: any SubscribePlaylistUseCase {
        return appComponent.subscribePlaylistUseCase
    }
    var checkSubscriptionUseCase: any CheckSubscriptionUseCase {
        return appComponent.checkSubscriptionUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->UnknownPlaylistDetailComponent
@MainActor private func factorya6d30d5b4471815dceb2f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return UnknownPlaylistDetailDependency7288879231117fbf1b1bProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class CheckPlaylistCoverDependency8efc6117f6bae3f05ffdProvider: @preconcurrency CheckPlaylistCoverDependency {
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->CheckPlaylistCoverComponent
@MainActor private func factory025ce9f6d91409a9f719f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CheckPlaylistCoverDependency8efc6117f6bae3f05ffdProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class FruitStorageDependencybef279261018fd1c1669Provider: @preconcurrency FruitStorageDependency {
    var fetchFruitListUseCase: any FetchFruitListUseCase {
        return appComponent.fetchFruitListUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->FruitStorageComponent
@MainActor private func factory070e42b0224381c8cdf4f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return FruitStorageDependencybef279261018fd1c1669Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class FruitDrawDependency55f36ae08a622ad39d3fProvider: @preconcurrency FruitDrawDependency {
    var fetchFruitDrawStatusUseCase: any FetchFruitDrawStatusUseCase {
        return appComponent.fetchFruitDrawStatusUseCase
    }
    var drawFruitUseCase: any DrawFruitUseCase {
        return appComponent.drawFruitUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->FruitDrawComponent
@MainActor private func factoryc603eb682d7a111dc261f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return FruitDrawDependency55f36ae08a622ad39d3fProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class CreditSongListTabItemDependency454e93d0f00e09bca0b5Provider: @preconcurrency CreditSongListTabItemDependency {
    var fetchCreditSongListUseCase: any FetchCreditSongListUseCase {
        return appComponent.fetchCreditSongListUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->CreditSongListTabItemComponent
@MainActor private func factory95828465b02bfed94ec5f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CreditSongListTabItemDependency454e93d0f00e09bca0b5Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class CreditSongListTabDependencybdb2c08847a72c255a37Provider: @preconcurrency CreditSongListTabDependency {
    var creditSongListTabItemFactory: any CreditSongListTabItemFactory {
        return appComponent.creditSongListTabItemFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->CreditSongListTabComponent
@MainActor private func factory85beabbf7f1f193dec41f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CreditSongListTabDependencybdb2c08847a72c255a37Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class CreditSongListDependencye5d029d068347ee34e68Provider: @preconcurrency CreditSongListDependency {
    var creditSongListTabFactory: any CreditSongListTabFactory {
        return appComponent.creditSongListTabFactory
    }
    var fetchCreditProfileUseCase: any FetchCreditProfileUseCase {
        return appComponent.fetchCreditProfileUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->CreditSongListComponent
@MainActor private func factorye0caf4db37d0954ab34ef47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CreditSongListDependencye5d029d068347ee34e68Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ChartDependencyafd8882010751c9ef054Provider: @preconcurrency ChartDependency {
    var chartContentComponent: ChartContentComponent {
        return appComponent.chartContentComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ChartComponent
@MainActor private func factoryeac6a4df54bbd391d31bf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ChartDependencyafd8882010751c9ef054Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ChartContentDependency3b8e41cfba060e4d16caProvider: @preconcurrency ChartContentDependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase {
        return appComponent.fetchChartRankingUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ChartContentComponent
@MainActor private func factoryc9a137630ce76907f36ff47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ChartContentDependency3b8e41cfba060e4d16caProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class TeamInfoDependency94c25b4e5acfbc37741cProvider: @preconcurrency TeamInfoDependency {
    var fetchTeamListUseCase: any FetchTeamListUseCase {
        return appComponent.fetchTeamListUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->TeamInfoComponent
@MainActor private func factorybe60e92b5190e00abf41f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return TeamInfoDependency94c25b4e5acfbc37741cProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class StorageDependency1447167c38e97ef97427Provider: @preconcurrency StorageDependency {
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var multiPurposePopupFactory: any MultiPurposePopupFactory {
        return appComponent.multiPurposePopupFactory
    }
    var listStorageComponent: ListStorageComponent {
        return appComponent.listStorageComponent
    }
    var likeStorageComponent: LikeStorageComponent {
        return appComponent.likeStorageComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->StorageComponent
@MainActor private func factory2415399d25299b97b98bf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return StorageDependency1447167c38e97ef97427Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ListStorageDependency77e3806cde238dfa4bf2Provider: @preconcurrency ListStorageDependency {
    var multiPurposePopupFactory: any MultiPurposePopupFactory {
        return appComponent.multiPurposePopupFactory
    }
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    var createPlaylistUseCase: any CreatePlaylistUseCase {
        return appComponent.createPlaylistUseCase
    }
    var editPlayListOrderUseCase: any EditPlaylistOrderUseCase {
        return appComponent.editPlayListOrderUseCase
    }
    var fetchPlayListUseCase: any FetchPlaylistUseCase {
        return appComponent.fetchPlayListUseCase
    }
    var deletePlayListUseCase: any DeletePlaylistUseCase {
        return appComponent.deletePlayListUseCase
    }
    var fetchPlaylistSongsUseCase: any FetchPlaylistSongsUseCase {
        return appComponent.fetchPlaylistSongsUseCase
    }
    var fetchPlaylistCreationPriceUseCase: any FetchPlaylistCreationPriceUseCase {
        return appComponent.fetchPlaylistCreationPriceUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var fruitDrawFactory: any FruitDrawFactory {
        return appComponent.fruitDrawFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ListStorageComponent
@MainActor private func factory75c66cb7534f04d45951f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ListStorageDependency77e3806cde238dfa4bf2Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class LikeStorageDependency00a252a1ff3ab6e82ceeProvider: @preconcurrency LikeStorageDependency {
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase {
        return appComponent.fetchFavoriteSongsUseCase
    }
    var editFavoriteSongsOrderUseCase: any EditFavoriteSongsOrderUseCase {
        return appComponent.editFavoriteSongsOrderUseCase
    }
    var deleteFavoriteListUseCase: any DeleteFavoriteListUseCase {
        return appComponent.deleteFavoriteListUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->LikeStorageComponent
@MainActor private func factory9f7222d7c56236b2e993f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LikeStorageDependency00a252a1ff3ab6e82ceeProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class RootDependency3944cc797a4a88956fb5Provider: @preconcurrency RootDependency {
    var mainContainerComponent: MainContainerComponent {
        return appComponent.mainContainerComponent
    }
    var permissionComponent: PermissionComponent {
        return appComponent.permissionComponent
    }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase {
        return appComponent.fetchUserInfoUseCase
    }
    var fetchAppCheckUseCase: any FetchAppCheckUseCase {
        return appComponent.fetchAppCheckUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var checkIsExistAccessTokenUseCase: any CheckIsExistAccessTokenUseCase {
        return appComponent.checkIsExistAccessTokenUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->RootComponent
@MainActor private func factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RootDependency3944cc797a4a88956fb5Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class PermissionDependency517ed7598d8c08817d14Provider: @preconcurrency PermissionDependency {


    init() {

    }
}
/// ^->AppComponent->PermissionComponent
@MainActor private func factoryc1d4d80afbccf86bf1c0e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PermissionDependency517ed7598d8c08817d14Provider()
}
@MainActor private class SignInDependency5dda0dd015447272446cProvider: @preconcurrency SignInDependency {
    var fetchTokenUseCase: any FetchTokenUseCase {
        return appComponent.fetchTokenUseCase
    }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase {
        return appComponent.fetchUserInfoUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SignInComponent
@MainActor private func factoryda2925fd76da866a652af47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SignInDependency5dda0dd015447272446cProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class NewSongsDependencyee634cc0cae21fc2a9e3Provider: @preconcurrency NewSongsDependency {
    var newSongsContentComponent: NewSongsContentComponent {
        return appComponent.newSongsContentComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->NewSongsComponent
@MainActor private func factory379179b05dd24ff979edf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NewSongsDependencyee634cc0cae21fc2a9e3Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class HomeDependency443c4e1871277bd8432aProvider: @preconcurrency HomeDependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase {
        return appComponent.fetchChartRankingUseCase
    }
    var fetchNewSongsUseCase: any FetchNewSongsUseCase {
        return appComponent.fetchNewSongsUseCase
    }
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase {
        return appComponent.fetchRecommendPlaylistUseCase
    }
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    var chartFactory: any ChartFactory {
        return appComponent.chartFactory
    }
    var newSongsComponent: NewSongsComponent {
        return appComponent.newSongsComponent
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->HomeComponent
@MainActor private func factory67229cdf0f755562b2b1f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return HomeDependency443c4e1871277bd8432aProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class NewSongsContentDependency93a05f20fa300c5bbec3Provider: @preconcurrency NewSongsContentDependency {
    var fetchNewSongsUseCase: any FetchNewSongsUseCase {
        return appComponent.fetchNewSongsUseCase
    }
    var fetchNewSongsPlaylistUseCase: any FetchNewSongsPlaylistUseCase {
        return appComponent.fetchNewSongsPlaylistUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->NewSongsContentComponent
@MainActor private func factorye130e1fbfcbc622a4c38f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NewSongsContentDependency93a05f20fa300c5bbec3Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class WakmusicRecommendDependency7d2e1de16b5802ae90ceProvider: @preconcurrency WakmusicRecommendDependency {
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase {
        return appComponent.fetchRecommendPlaylistUseCase
    }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory {
        return appComponent.wakmusicPlaylistDetailFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->WakmusicRecommendComponent
@MainActor private func factoryaf1c3535530356714983f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return WakmusicRecommendDependency7d2e1de16b5802ae90ceProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class BeforeSearchDependencyebdecb1d478a4766488dProvider: @preconcurrency BeforeSearchDependency {
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase {
        return appComponent.fetchRecommendPlaylistUseCase
    }
    var fetchCurrentVideoUseCase: any FetchCurrentVideoUseCase {
        return appComponent.fetchCurrentVideoUseCase
    }
    var wakmusicRecommendComponent: WakmusicRecommendComponent {
        return appComponent.wakmusicRecommendComponent
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->BeforeSearchComponent
@MainActor private func factory9bb852337d5550979293f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return BeforeSearchDependencyebdecb1d478a4766488dProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class SearchDependencya86903a2c751a4f762e8Provider: @preconcurrency SearchDependency {
    var beforeSearchComponent: BeforeSearchComponent {
        return appComponent.beforeSearchComponent
    }
    var afterSearchComponent: AfterSearchComponent {
        return appComponent.afterSearchComponent
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol {
        return appComponent.searchGlobalScrollState
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SearchComponent
@MainActor private func factorye3d049458b2ccbbcb3b6f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SearchDependencya86903a2c751a4f762e8Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class AfterSearchDependency61822c19bc2eb46d7c52Provider: @preconcurrency AfterSearchDependency {
    var songSearchResultFactory: any SongSearchResultFactory {
        return appComponent.songSearchResultFactory
    }
    var listSearchResultFactory: any ListSearchResultFactory {
        return appComponent.listSearchResultFactory
    }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol {
        return appComponent.searchGlobalScrollState
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AfterSearchComponent
@MainActor private func factoryeb2da679e35e2c4fb9a5f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AfterSearchDependency61822c19bc2eb46d7c52Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ListSearchResultDependencyd64afa403e14dc980d2fProvider: @preconcurrency ListSearchResultDependency {
    var fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase {
        return appComponent.fetchSearchPlaylistsUseCase
    }
    var searchSortOptionComponent: SearchSortOptionComponent {
        return appComponent.searchSortOptionComponent
    }
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol {
        return appComponent.searchGlobalScrollState
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ListSearchResultComponent
@MainActor private func factory2c8e2a50d1fcf9efc9f8f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ListSearchResultDependencyd64afa403e14dc980d2fProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class SongSearchResultDependency7224c47222c188cd3de5Provider: @preconcurrency SongSearchResultDependency {
    var fetchSearchSongsUseCase: any FetchSearchSongsUseCase {
        return appComponent.fetchSearchSongsUseCase
    }
    var searchSortOptionComponent: SearchSortOptionComponent {
        return appComponent.searchSortOptionComponent
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol {
        return appComponent.searchGlobalScrollState
    }
    var songDetailPresenter: any SongDetailPresentable {
        return appComponent.songDetailPresenter
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SongSearchResultComponent
@MainActor private func factory182af2382ca6172f89c1f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SongSearchResultDependency7224c47222c188cd3de5Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ContainSongsDependencydbd9ae8a072db3a22630Provider: @preconcurrency ContainSongsDependency {
    var multiPurposePopupFactory: any MultiPurposePopupFactory {
        return appComponent.multiPurposePopupFactory
    }
    var fetchPlayListUseCase: any FetchPlaylistUseCase {
        return appComponent.fetchPlayListUseCase
    }
    var addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase {
        return appComponent.addSongIntoPlaylistUseCase
    }
    var createPlaylistUseCase: any CreatePlaylistUseCase {
        return appComponent.createPlaylistUseCase
    }
    var fetchPlaylistCreationPriceUseCase: any FetchPlaylistCreationPriceUseCase {
        return appComponent.fetchPlaylistCreationPriceUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ContainSongsComponent
@MainActor private func factory4d4f4455414271fee232f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ContainSongsDependencydbd9ae8a072db3a22630Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class ServiceTermsDependencyd07df8dc0771e5580b47Provider: @preconcurrency ServiceTermsDependency {


    init() {

    }
}
/// ^->AppComponent->ServiceTermsComponent
@MainActor private func factory8014909e2d8dba4e4f20e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ServiceTermsDependencyd07df8dc0771e5580b47Provider()
}
@MainActor private class PrivacyDependency51c6df0186843bf53e9cProvider: @preconcurrency PrivacyDependency {


    init() {

    }
}
/// ^->AppComponent->PrivacyComponent
@MainActor private func factorye7f5d59533cfdd1614b0e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PrivacyDependency51c6df0186843bf53e9cProvider()
}
@MainActor private class ServiceInfoDependency17ccca17be0fc87c9a2eProvider: @preconcurrency ServiceInfoDependency {
    var openSourceLicenseFactory: any OpenSourceLicenseFactory {
        return appComponent.openSourceLicenseFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ServiceInfoComponent
@MainActor private func factory3afd170b9974b0dbd863f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ServiceInfoDependency17ccca17be0fc87c9a2eProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class FaqDependency899aad15f17210a3af31Provider: @preconcurrency FaqDependency {
    var faqContentFactory: any FaqContentFactory {
        return appComponent.faqContentFactory
    }
    var fetchFaqCategoriesUseCase: any FetchFaqCategoriesUseCase {
        return appComponent.fetchFaqCategoriesUseCase
    }
    var fetchFaqUseCase: any FetchFaqUseCase {
        return appComponent.fetchFaqUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->FaqComponent
@MainActor private func factory4e13cc6545633ffc2ed5f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return FaqDependency899aad15f17210a3af31Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class QuestionDependencyf7010567c2d88e76d191Provider: @preconcurrency QuestionDependency {
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->QuestionComponent
@MainActor private func factoryedad1813a36115eec11ef47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return QuestionDependencyf7010567c2d88e76d191Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class MyInfoDependency3b44bce00dab6fc2e345Provider: @preconcurrency MyInfoDependency {
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var multiPurposePopupFactory: any MultiPurposePopupFactory {
        return appComponent.multiPurposePopupFactory
    }
    var faqFactory: any FaqFactory {
        return appComponent.faqFactory
    }
    var noticeFactory: any NoticeFactory {
        return appComponent.noticeFactory
    }
    var questionFactory: any QuestionFactory {
        return appComponent.questionFactory
    }
    var teamInfoFactory: any TeamInfoFactory {
        return appComponent.teamInfoFactory
    }
    var settingFactory: any SettingFactory {
        return appComponent.settingFactory
    }
    var profilePopupFactory: any ProfilePopupFactory {
        return appComponent.profilePopupFactory
    }
    var fruitDrawFactory: any FruitDrawFactory {
        return appComponent.fruitDrawFactory
    }
    var fruitStorageFactory: any FruitStorageFactory {
        return appComponent.fruitStorageFactory
    }
    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase {
        return appComponent.fetchNoticeIDListUseCase
    }
    var setUserNameUseCase: any SetUserNameUseCase {
        return appComponent.setUserNameUseCase
    }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase {
        return appComponent.fetchUserInfoUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MyInfoComponent
@MainActor private func factoryec2cede3edc2a626b35df47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MyInfoDependency3b44bce00dab6fc2e345Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class SettingDependency792c9caceb5cb097fbecProvider: @preconcurrency SettingDependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase {
        return appComponent.withdrawUserInfoUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var updateNotificationTokenUseCase: any UpdateNotificationTokenUseCase {
        return appComponent.updateNotificationTokenUseCase
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var serviceTermsFactory: any ServiceTermFactory {
        return appComponent.serviceTermsFactory
    }
    var privacyFactory: any PrivacyFactory {
        return appComponent.privacyFactory
    }
    var openSourceLicenseFactory: any OpenSourceLicenseFactory {
        return appComponent.openSourceLicenseFactory
    }
    var playTypeTogglePopupFactory: any PlayTypeTogglePopupFactory {
        return appComponent.playTypeTogglePopupFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SettingComponent
@MainActor private func factoryee0bbc0b920a7007e1a9f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SettingDependency792c9caceb5cb097fbecProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class NoticeDetailDependency714af3aed40eaebda420Provider: @preconcurrency NoticeDetailDependency {


    init() {

    }
}
/// ^->AppComponent->NoticeDetailComponent
@MainActor private func factory3db143c2f80d621d5a7fe3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NoticeDetailDependency714af3aed40eaebda420Provider()
}
@MainActor private class ProfilePopupDependency3d548bc7afc8d2b8f092Provider: @preconcurrency ProfilePopupDependency {
    var fetchProfileListUseCase: any FetchProfileListUseCase {
        return appComponent.fetchProfileListUseCase
    }
    var setProfileUseCase: any SetProfileUseCase {
        return appComponent.setProfileUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ProfilePopupComponent
@MainActor private func factory3a1ad3396729bed7200ef47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ProfilePopupDependency3d548bc7afc8d2b8f092Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class OpenSourceLicenseDependencyb6842dcc36b26380b91aProvider: @preconcurrency OpenSourceLicenseDependency {


    init() {

    }
}
/// ^->AppComponent->OpenSourceLicenseComponent
@MainActor private func factoryd505894818021731340ae3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OpenSourceLicenseDependencyb6842dcc36b26380b91aProvider()
}
@MainActor private class NoticeDependencyaec92ef53617a421bdf3Provider: @preconcurrency NoticeDependency {
    var fetchNoticeAllUseCase: any FetchNoticeAllUseCase {
        return appComponent.fetchNoticeAllUseCase
    }
    var noticeDetailFactory: any NoticeDetailFactory {
        return appComponent.noticeDetailFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->NoticeComponent
@MainActor private func factoryaf8e5665e5b9217918f5f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NoticeDependencyaec92ef53617a421bdf3Provider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class SongCreditDependency973cc2df82285f0722fcProvider: @preconcurrency SongCreditDependency {
    var fetchSongCreditsUseCase: any FetchSongCreditsUseCase {
        return appComponent.fetchSongCreditsUseCase
    }
    var creditSongListFactory: any CreditSongListFactory {
        return appComponent.creditSongListFactory
    }
    var artistDetailFactory: any ArtistDetailFactory {
        return appComponent.artistDetailFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SongCreditComponent
@MainActor private func factoryd48a3e0e81529a27a02bf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SongCreditDependency973cc2df82285f0722fcProvider(appComponent: parent1(component) as! AppComponent)
}
@MainActor private class MusicDetailDependencyb872e53d21248eec044dProvider: @preconcurrency MusicDetailDependency {
    var fetchSongUseCase: any FetchSongUseCase {
        return appComponent.fetchSongUseCase
    }
    var lyricHighlightingFactory: any LyricHighlightingFactory {
        return appComponent.lyricHighlightingFactory
    }
    var songCreditFactory: any SongCreditFactory {
        return appComponent.songCreditFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var karaokeFactory: any KaraokeFactory {
        return appComponent.karaokeFactory
    }
    var textPopupFactory: any TextPopupFactory {
        return appComponent.textPopupFactory
    }
    var artistDetailFactory: any ArtistDetailFactory {
        return appComponent.artistDetailFactory
    }
    var playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol {
        return appComponent.playlistPresenterGlobalState
    }
    var addLikeSongUseCase: any AddLikeSongUseCase {
        return appComponent.addLikeSongUseCase
    }
    var cancelLikeSongUseCase: any CancelLikeSongUseCase {
        return appComponent.cancelLikeSongUseCase
    }
    var findArtistIDUseCase: any FindArtistIDUseCase {
        return appComponent.findArtistIDUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MusicDetailComponent
@MainActor private func factory84f307443e9a78802606f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MusicDetailDependencyb872e53d21248eec044dProvider(appComponent: parent1(component) as! AppComponent)
}

#else
@MainActor extension AppComponent: Registration {
    public func registerItems() {

        localTable["keychain-any Keychain"] = { [unowned self] in self.keychain as Any }
        localTable["remoteImageDataSource-any RemoteImageDataSource"] = { [unowned self] in self.remoteImageDataSource as Any }
        localTable["imageRepository-any ImageRepository"] = { [unowned self] in self.imageRepository as Any }
        localTable["fetchLyricDecoratingBackgroundUseCase-any FetchLyricDecoratingBackgroundUseCase"] = { [unowned self] in self.fetchLyricDecoratingBackgroundUseCase as Any }
        localTable["fetchProfileListUseCase-any FetchProfileListUseCase"] = { [unowned self] in self.fetchProfileListUseCase as Any }
        localTable["fetchDefaultPlaylistImageUseCase-any FetchDefaultPlaylistImageUseCase"] = { [unowned self] in self.fetchDefaultPlaylistImageUseCase as Any }
        localTable["songDetailPresenter-any SongDetailPresentable"] = { [unowned self] in self.songDetailPresenter as Any }
        localTable["homeFactory-any HomeFactory"] = { [unowned self] in self.homeFactory as Any }
        localTable["musicDetailFactory-any MusicDetailFactory"] = { [unowned self] in self.musicDetailFactory as Any }
        localTable["karaokeFactory-any KaraokeFactory"] = { [unowned self] in self.karaokeFactory as Any }
        localTable["newSongsComponent-NewSongsComponent"] = { [unowned self] in self.newSongsComponent as Any }
        localTable["newSongsContentComponent-NewSongsContentComponent"] = { [unowned self] in self.newSongsContentComponent as Any }
        localTable["lyricHighlightingFactory-any LyricHighlightingFactory"] = { [unowned self] in self.lyricHighlightingFactory as Any }
        localTable["lyricDecoratingComponent-LyricDecoratingComponent"] = { [unowned self] in self.lyricDecoratingComponent as Any }
        localTable["remoteSongsDataSource-any RemoteSongsDataSource"] = { [unowned self] in self.remoteSongsDataSource as Any }
        localTable["songsRepository-any SongsRepository"] = { [unowned self] in self.songsRepository as Any }
        localTable["fetchSongUseCase-any FetchSongUseCase"] = { [unowned self] in self.fetchSongUseCase as Any }
        localTable["fetchLyricsUseCase-any FetchLyricsUseCase"] = { [unowned self] in self.fetchLyricsUseCase as Any }
        localTable["fetchNewSongsUseCase-any FetchNewSongsUseCase"] = { [unowned self] in self.fetchNewSongsUseCase as Any }
        localTable["fetchNewSongsPlaylistUseCase-any FetchNewSongsPlaylistUseCase"] = { [unowned self] in self.fetchNewSongsPlaylistUseCase as Any }
        localTable["fetchSongCreditsUseCase-any FetchSongCreditsUseCase"] = { [unowned self] in self.fetchSongCreditsUseCase as Any }
        localTable["remoteCreditDataSource-any RemoteCreditDataSource"] = { [unowned self] in self.remoteCreditDataSource as Any }
        localTable["creditRepository-any CreditRepository"] = { [unowned self] in self.creditRepository as Any }
        localTable["fetchCreditSongListUseCase-any FetchCreditSongListUseCase"] = { [unowned self] in self.fetchCreditSongListUseCase as Any }
        localTable["fetchCreditProfileUseCase-any FetchCreditProfileUseCase"] = { [unowned self] in self.fetchCreditProfileUseCase as Any }
        localTable["songCreditFactory-any SongCreditFactory"] = { [unowned self] in self.songCreditFactory as Any }
        localTable["creditSongListFactory-any CreditSongListFactory"] = { [unowned self] in self.creditSongListFactory as Any }
        localTable["creditSongListTabFactory-any CreditSongListTabFactory"] = { [unowned self] in self.creditSongListTabFactory as Any }
        localTable["creditSongListTabItemFactory-any CreditSongListTabItemFactory"] = { [unowned self] in self.creditSongListTabItemFactory as Any }
        localTable["remoteNotificationDataSource-any RemoteNotificationDataSource"] = { [unowned self] in self.remoteNotificationDataSource as Any }
        localTable["notificationRepository-any NotificationRepository"] = { [unowned self] in self.notificationRepository as Any }
        localTable["updateNotificationTokenUseCase-any UpdateNotificationTokenUseCase"] = { [unowned self] in self.updateNotificationTokenUseCase as Any }
        localTable["signInFactory-any SignInFactory"] = { [unowned self] in self.signInFactory as Any }
        localTable["localAuthDataSource-any LocalAuthDataSource"] = { [unowned self] in self.localAuthDataSource as Any }
        localTable["remoteAuthDataSource-any RemoteAuthDataSource"] = { [unowned self] in self.remoteAuthDataSource as Any }
        localTable["authRepository-any AuthRepository"] = { [unowned self] in self.authRepository as Any }
        localTable["fetchTokenUseCase-any FetchTokenUseCase"] = { [unowned self] in self.fetchTokenUseCase as Any }
        localTable["regenerateAccessTokenUseCase-any ReGenerateAccessTokenUseCase"] = { [unowned self] in self.regenerateAccessTokenUseCase as Any }
        localTable["logoutUseCase-any LogoutUseCase"] = { [unowned self] in self.logoutUseCase as Any }
        localTable["checkIsExistAccessTokenUseCase-any CheckIsExistAccessTokenUseCase"] = { [unowned self] in self.checkIsExistAccessTokenUseCase as Any }
        localTable["remoteLikeDataSource-any RemoteLikeDataSource"] = { [unowned self] in self.remoteLikeDataSource as Any }
        localTable["likeRepository-any LikeRepository"] = { [unowned self] in self.likeRepository as Any }
        localTable["addLikeSongUseCase-any AddLikeSongUseCase"] = { [unowned self] in self.addLikeSongUseCase as Any }
        localTable["cancelLikeSongUseCase-any CancelLikeSongUseCase"] = { [unowned self] in self.cancelLikeSongUseCase as Any }
        localTable["playlistPresenterGlobalState-any PlayListPresenterGlobalStateProtocol"] = { [unowned self] in self.playlistPresenterGlobalState as Any }
        localTable["playlistDetailFactory-any PlaylistDetailFactory"] = { [unowned self] in self.playlistDetailFactory as Any }
        localTable["playlistFactory-any PlaylistFactory"] = { [unowned self] in self.playlistFactory as Any }
        localTable["myPlaylistDetailFactory-any MyPlaylistDetailFactory"] = { [unowned self] in self.myPlaylistDetailFactory as Any }
        localTable["unknownPlaylistDetailFactory-any UnknownPlaylistDetailFactory"] = { [unowned self] in self.unknownPlaylistDetailFactory as Any }
        localTable["wakmusicPlaylistDetailFactory-any WakmusicPlaylistDetailFactory"] = { [unowned self] in self.wakmusicPlaylistDetailFactory as Any }
        localTable["playlistCoverOptionPopupFactory-any PlaylistCoverOptionPopupFactory"] = { [unowned self] in self.playlistCoverOptionPopupFactory as Any }
        localTable["checkPlaylistCoverFactory-any CheckPlaylistCoverFactory"] = { [unowned self] in self.checkPlaylistCoverFactory as Any }
        localTable["defaultPlaylistCoverFactory-any DefaultPlaylistCoverFactory"] = { [unowned self] in self.defaultPlaylistCoverFactory as Any }
        localTable["remotePlaylistDataSource-any RemotePlaylistDataSource"] = { [unowned self] in self.remotePlaylistDataSource as Any }
        localTable["playlistRepository-any PlaylistRepository"] = { [unowned self] in self.playlistRepository as Any }
        localTable["fetchRecommendPlaylistUseCase-any FetchRecommendPlaylistUseCase"] = { [unowned self] in self.fetchRecommendPlaylistUseCase as Any }
        localTable["fetchPlaylistSongsUseCase-any FetchPlaylistSongsUseCase"] = { [unowned self] in self.fetchPlaylistSongsUseCase as Any }
        localTable["fetchPlaylistDetailUseCase-any FetchPlaylistDetailUseCase"] = { [unowned self] in self.fetchPlaylistDetailUseCase as Any }
        localTable["fetchWMPlaylistDetailUseCase-any FetchWMPlaylistDetailUseCase"] = { [unowned self] in self.fetchWMPlaylistDetailUseCase as Any }
        localTable["createPlaylistUseCase-any CreatePlaylistUseCase"] = { [unowned self] in self.createPlaylistUseCase as Any }
        localTable["updatePlaylistUseCase-any UpdatePlaylistUseCase"] = { [unowned self] in self.updatePlaylistUseCase as Any }
        localTable["updateTitleAndPrivateUseCase-any UpdateTitleAndPrivateUseCase"] = { [unowned self] in self.updateTitleAndPrivateUseCase as Any }
        localTable["addSongIntoPlaylistUseCase-any AddSongIntoPlaylistUseCase"] = { [unowned self] in self.addSongIntoPlaylistUseCase as Any }
        localTable["removeSongsUseCase-any RemoveSongsUseCase"] = { [unowned self] in self.removeSongsUseCase as Any }
        localTable["subscribePlaylistUseCase-any SubscribePlaylistUseCase"] = { [unowned self] in self.subscribePlaylistUseCase as Any }
        localTable["checkSubscriptionUseCase-any CheckSubscriptionUseCase"] = { [unowned self] in self.checkSubscriptionUseCase as Any }
        localTable["uploadDefaultPlaylistImageUseCase-any UploadDefaultPlaylistImageUseCase"] = { [unowned self] in self.uploadDefaultPlaylistImageUseCase as Any }
        localTable["requestCustomImageURLUseCase-any RequestCustomImageURLUseCase"] = { [unowned self] in self.requestCustomImageURLUseCase as Any }
        localTable["requestPlaylistOwnerIDUsecase-any RequestPlaylistOwnerIDUsecase"] = { [unowned self] in self.requestPlaylistOwnerIDUsecase as Any }
        localTable["artistFactory-any ArtistFactory"] = { [unowned self] in self.artistFactory as Any }
        localTable["remoteArtistDataSource-RemoteArtistDataSourceImpl"] = { [unowned self] in self.remoteArtistDataSource as Any }
        localTable["artistRepository-any ArtistRepository"] = { [unowned self] in self.artistRepository as Any }
        localTable["fetchArtistListUseCase-any FetchArtistListUseCase"] = { [unowned self] in self.fetchArtistListUseCase as Any }
        localTable["artistDetailFactory-any ArtistDetailFactory"] = { [unowned self] in self.artistDetailFactory as Any }
        localTable["fetchArtistDetailUseCase-any FetchArtistDetailUseCase"] = { [unowned self] in self.fetchArtistDetailUseCase as Any }
        localTable["fetchArtistSongListUseCase-any FetchArtistSongListUseCase"] = { [unowned self] in self.fetchArtistSongListUseCase as Any }
        localTable["fetchArtistSubscriptionStatusUseCase-any FetchArtistSubscriptionStatusUseCase"] = { [unowned self] in self.fetchArtistSubscriptionStatusUseCase as Any }
        localTable["subscriptionArtistUseCase-any SubscriptionArtistUseCase"] = { [unowned self] in self.subscriptionArtistUseCase as Any }
        localTable["findArtistIDUseCase-any FindArtistIDUseCase"] = { [unowned self] in self.findArtistIDUseCase as Any }
        localTable["artistMusicComponent-ArtistMusicComponent"] = { [unowned self] in self.artistMusicComponent as Any }
        localTable["artistMusicContentComponent-ArtistMusicContentComponent"] = { [unowned self] in self.artistMusicContentComponent as Any }
        localTable["remoteUserDataSource-any RemoteUserDataSource"] = { [unowned self] in self.remoteUserDataSource as Any }
        localTable["userRepository-any UserRepository"] = { [unowned self] in self.userRepository as Any }
        localTable["setProfileUseCase-any SetProfileUseCase"] = { [unowned self] in self.setProfileUseCase as Any }
        localTable["setUserNameUseCase-any SetUserNameUseCase"] = { [unowned self] in self.setUserNameUseCase as Any }
        localTable["fetchPlayListUseCase-any FetchPlaylistUseCase"] = { [unowned self] in self.fetchPlayListUseCase as Any }
        localTable["fetchFavoriteSongsUseCase-any FetchFavoriteSongsUseCase"] = { [unowned self] in self.fetchFavoriteSongsUseCase as Any }
        localTable["editFavoriteSongsOrderUseCase-any EditFavoriteSongsOrderUseCase"] = { [unowned self] in self.editFavoriteSongsOrderUseCase as Any }
        localTable["editPlayListOrderUseCase-any EditPlaylistOrderUseCase"] = { [unowned self] in self.editPlayListOrderUseCase as Any }
        localTable["deletePlayListUseCase-any DeletePlaylistUseCase"] = { [unowned self] in self.deletePlayListUseCase as Any }
        localTable["deleteFavoriteListUseCase-any DeleteFavoriteListUseCase"] = { [unowned self] in self.deleteFavoriteListUseCase as Any }
        localTable["fetchUserInfoUseCase-any FetchUserInfoUseCase"] = { [unowned self] in self.fetchUserInfoUseCase as Any }
        localTable["withdrawUserInfoUseCase-any WithdrawUserInfoUseCase"] = { [unowned self] in self.withdrawUserInfoUseCase as Any }
        localTable["fetchFruitListUseCase-any FetchFruitListUseCase"] = { [unowned self] in self.fetchFruitListUseCase as Any }
        localTable["fetchFruitDrawStatusUseCase-any FetchFruitDrawStatusUseCase"] = { [unowned self] in self.fetchFruitDrawStatusUseCase as Any }
        localTable["drawFruitUseCase-any DrawFruitUseCase"] = { [unowned self] in self.drawFruitUseCase as Any }
        localTable["mainContainerComponent-MainContainerComponent"] = { [unowned self] in self.mainContainerComponent as Any }
        localTable["bottomTabBarComponent-BottomTabBarComponent"] = { [unowned self] in self.bottomTabBarComponent as Any }
        localTable["mainTabBarComponent-MainTabBarComponent"] = { [unowned self] in self.mainTabBarComponent as Any }
        localTable["appEntryState-any AppEntryStateHandleable"] = { [unowned self] in self.appEntryState as Any }
        localTable["permissionComponent-PermissionComponent"] = { [unowned self] in self.permissionComponent as Any }
        localTable["teamInfoFactory-any TeamInfoFactory"] = { [unowned self] in self.teamInfoFactory as Any }
        localTable["remoteTeamDataSource-any RemoteTeamDataSource"] = { [unowned self] in self.remoteTeamDataSource as Any }
        localTable["teamRepository-any TeamRepository"] = { [unowned self] in self.teamRepository as Any }
        localTable["fetchTeamListUseCase-any FetchTeamListUseCase"] = { [unowned self] in self.fetchTeamListUseCase as Any }
        localTable["noticePopupComponent-NoticePopupComponent"] = { [unowned self] in self.noticePopupComponent as Any }
        localTable["noticeFactory-any NoticeFactory"] = { [unowned self] in self.noticeFactory as Any }
        localTable["noticeDetailFactory-any NoticeDetailFactory"] = { [unowned self] in self.noticeDetailFactory as Any }
        localTable["remoteNoticeDataSource-any RemoteNoticeDataSource"] = { [unowned self] in self.remoteNoticeDataSource as Any }
        localTable["noticeRepository-any NoticeRepository"] = { [unowned self] in self.noticeRepository as Any }
        localTable["fetchNoticeAllUseCase-any FetchNoticeAllUseCase"] = { [unowned self] in self.fetchNoticeAllUseCase as Any }
        localTable["fetchNoticePopupUseCase-any FetchNoticePopupUseCase"] = { [unowned self] in self.fetchNoticePopupUseCase as Any }
        localTable["fetchNoticeCategoriesUseCase-any FetchNoticeCategoriesUseCase"] = { [unowned self] in self.fetchNoticeCategoriesUseCase as Any }
        localTable["fetchNoticeIDListUseCase-any FetchNoticeIDListUseCase"] = { [unowned self] in self.fetchNoticeIDListUseCase as Any }
        localTable["multiPurposePopupFactory-any MultiPurposePopupFactory"] = { [unowned self] in self.multiPurposePopupFactory as Any }
        localTable["textPopupFactory-any TextPopupFactory"] = { [unowned self] in self.textPopupFactory as Any }
        localTable["containSongsFactory-any ContainSongsFactory"] = { [unowned self] in self.containSongsFactory as Any }
        localTable["privacyFactory-any PrivacyFactory"] = { [unowned self] in self.privacyFactory as Any }
        localTable["serviceTermsFactory-any ServiceTermFactory"] = { [unowned self] in self.serviceTermsFactory as Any }
        localTable["storageFactory-any StorageFactory"] = { [unowned self] in self.storageFactory as Any }
        localTable["listStorageComponent-ListStorageComponent"] = { [unowned self] in self.listStorageComponent as Any }
        localTable["likeStorageComponent-LikeStorageComponent"] = { [unowned self] in self.likeStorageComponent as Any }
        localTable["remoteFaqDataSource-any RemoteFaqDataSource"] = { [unowned self] in self.remoteFaqDataSource as Any }
        localTable["faqRepository-any FaqRepository"] = { [unowned self] in self.faqRepository as Any }
        localTable["fetchFaqCategoriesUseCase-any FetchFaqCategoriesUseCase"] = { [unowned self] in self.fetchFaqCategoriesUseCase as Any }
        localTable["fetchFaqUseCase-any FetchFaqUseCase"] = { [unowned self] in self.fetchFaqUseCase as Any }
        localTable["remoteAppDataSource-any RemoteAppDataSource"] = { [unowned self] in self.remoteAppDataSource as Any }
        localTable["appRepository-any AppRepository"] = { [unowned self] in self.appRepository as Any }
        localTable["fetchAppCheckUseCase-any FetchAppCheckUseCase"] = { [unowned self] in self.fetchAppCheckUseCase as Any }
        localTable["chartFactory-any ChartFactory"] = { [unowned self] in self.chartFactory as Any }
        localTable["chartContentComponent-ChartContentComponent"] = { [unowned self] in self.chartContentComponent as Any }
        localTable["remoteChartDataSource-any RemoteChartDataSource"] = { [unowned self] in self.remoteChartDataSource as Any }
        localTable["chartRepository-any ChartRepository"] = { [unowned self] in self.chartRepository as Any }
        localTable["fetchChartRankingUseCase-any FetchChartRankingUseCase"] = { [unowned self] in self.fetchChartRankingUseCase as Any }
        localTable["fetchCurrentVideoUseCase-any FetchCurrentVideoUseCase"] = { [unowned self] in self.fetchCurrentVideoUseCase as Any }
    }
}
@MainActor extension ArtistComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistDependency.fetchArtistListUseCase] = "fetchArtistListUseCase-any FetchArtistListUseCase"
        keyPathToName[\ArtistDependency.artistDetailFactory] = "artistDetailFactory-any ArtistDetailFactory"
    }
}
@MainActor extension ArtistDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistDetailDependency.artistMusicComponent] = "artistMusicComponent-ArtistMusicComponent"
        keyPathToName[\ArtistDetailDependency.fetchArtistDetailUseCase] = "fetchArtistDetailUseCase-any FetchArtistDetailUseCase"
        keyPathToName[\ArtistDetailDependency.fetchArtistSubscriptionStatusUseCase] = "fetchArtistSubscriptionStatusUseCase-any FetchArtistSubscriptionStatusUseCase"
        keyPathToName[\ArtistDetailDependency.subscriptionArtistUseCase] = "subscriptionArtistUseCase-any SubscriptionArtistUseCase"
        keyPathToName[\ArtistDetailDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\ArtistDetailDependency.signInFactory] = "signInFactory-any SignInFactory"
    }
}
@MainActor extension ArtistMusicContentComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistMusicContentDependency.fetchArtistSongListUseCase] = "fetchArtistSongListUseCase-any FetchArtistSongListUseCase"
        keyPathToName[\ArtistMusicContentDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\ArtistMusicContentDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\ArtistMusicContentDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\ArtistMusicContentDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
    }
}
@MainActor extension ArtistMusicComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistMusicDependency.artistMusicContentComponent] = "artistMusicContentComponent-ArtistMusicContentComponent"
    }
}
@MainActor extension LyricHighlightingComponent: Registration {
    public func registerItems() {
        keyPathToName[\LyricHighlightingDependency.fetchLyricsUseCase] = "fetchLyricsUseCase-any FetchLyricsUseCase"
        keyPathToName[\LyricHighlightingDependency.lyricDecoratingComponent] = "lyricDecoratingComponent-LyricDecoratingComponent"
        keyPathToName[\LyricHighlightingDependency.lyricHighlightingFactory] = "lyricHighlightingFactory-any LyricHighlightingFactory"
    }
}
@MainActor extension LyricDecoratingComponent: Registration {
    public func registerItems() {
        keyPathToName[\LyricDecoratingDependency.fetchLyricDecoratingBackgroundUseCase] = "fetchLyricDecoratingBackgroundUseCase-any FetchLyricDecoratingBackgroundUseCase"
        keyPathToName[\LyricDecoratingDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension MainTabBarComponent: Registration {
    public func registerItems() {
        keyPathToName[\MainTabBarDependency.fetchNoticePopupUseCase] = "fetchNoticePopupUseCase-any FetchNoticePopupUseCase"
        keyPathToName[\MainTabBarDependency.fetchNoticeIDListUseCase] = "fetchNoticeIDListUseCase-any FetchNoticeIDListUseCase"
        keyPathToName[\MainTabBarDependency.updateNotificationTokenUseCase] = "updateNotificationTokenUseCase-any UpdateNotificationTokenUseCase"
        keyPathToName[\MainTabBarDependency.fetchSongUseCase] = "fetchSongUseCase-any FetchSongUseCase"
        keyPathToName[\MainTabBarDependency.appEntryState] = "appEntryState-any AppEntryStateHandleable"
        keyPathToName[\MainTabBarDependency.homeFactory] = "homeFactory-any HomeFactory"
        keyPathToName[\MainTabBarDependency.searchFactory] = "searchFactory-any SearchFactory"
        keyPathToName[\MainTabBarDependency.artistFactory] = "artistFactory-any ArtistFactory"
        keyPathToName[\MainTabBarDependency.storageFactory] = "storageFactory-any StorageFactory"
        keyPathToName[\MainTabBarDependency.myInfoFactory] = "myInfoFactory-any MyInfoFactory"
        keyPathToName[\MainTabBarDependency.noticePopupComponent] = "noticePopupComponent-NoticePopupComponent"
        keyPathToName[\MainTabBarDependency.noticeDetailFactory] = "noticeDetailFactory-any NoticeDetailFactory"
        keyPathToName[\MainTabBarDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
        keyPathToName[\MainTabBarDependency.musicDetailFactory] = "musicDetailFactory-any MusicDetailFactory"
        keyPathToName[\MainTabBarDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
    }
}
@MainActor extension BottomTabBarComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension MainContainerComponent: Registration {
    public func registerItems() {
        keyPathToName[\MainContainerDependency.bottomTabBarComponent] = "bottomTabBarComponent-BottomTabBarComponent"
        keyPathToName[\MainContainerDependency.mainTabBarComponent] = "mainTabBarComponent-MainTabBarComponent"
        keyPathToName[\MainContainerDependency.playlistFactory] = "playlistFactory-any PlaylistFactory"
        keyPathToName[\MainContainerDependency.playlistPresenterGlobalState] = "playlistPresenterGlobalState-any PlayListPresenterGlobalStateProtocol"
    }
}
@MainActor extension NoticePopupComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension PlaylistCoverOptionPopupComponent: Registration {
    public func registerItems() {
        keyPathToName[\PlaylistCoverOptionPopupDependency.fetchPlaylistImagePriceUseCase] = "fetchPlaylistImagePriceUseCase-any FetchPlaylistImagePriceUseCase"
    }
}
@MainActor extension PlaylistDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\PlaylistDetailFactoryDependency.myPlaylistDetailFactory] = "myPlaylistDetailFactory-any MyPlaylistDetailFactory"
        keyPathToName[\PlaylistDetailFactoryDependency.unknownPlaylistDetailFactory] = "unknownPlaylistDetailFactory-any UnknownPlaylistDetailFactory"
        keyPathToName[\PlaylistDetailFactoryDependency.wakmusicPlaylistDetailFactory] = "wakmusicPlaylistDetailFactory-any WakmusicPlaylistDetailFactory"
        keyPathToName[\PlaylistDetailFactoryDependency.requestPlaylistOwnerIDUsecase] = "requestPlaylistOwnerIDUsecase-any RequestPlaylistOwnerIDUsecase"
        keyPathToName[\PlaylistDetailFactoryDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension WakmusicPlaylistDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\WakmusicPlaylistDetailDependency.fetchWMPlaylistDetailUseCase] = "fetchWMPlaylistDetailUseCase-any FetchWMPlaylistDetailUseCase"
        keyPathToName[\WakmusicPlaylistDetailDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\WakmusicPlaylistDetailDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\WakmusicPlaylistDetailDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
        keyPathToName[\WakmusicPlaylistDetailDependency.signInFactory] = "signInFactory-any SignInFactory"
    }
}
@MainActor extension MyPlaylistDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\MyPlaylistDetailDependency.fetchPlaylistDetailUseCase] = "fetchPlaylistDetailUseCase-any FetchPlaylistDetailUseCase"
        keyPathToName[\MyPlaylistDetailDependency.updatePlaylistUseCase] = "updatePlaylistUseCase-any UpdatePlaylistUseCase"
        keyPathToName[\MyPlaylistDetailDependency.updateTitleAndPrivateUseCase] = "updateTitleAndPrivateUseCase-any UpdateTitleAndPrivateUseCase"
        keyPathToName[\MyPlaylistDetailDependency.removeSongsUseCase] = "removeSongsUseCase-any RemoveSongsUseCase"
        keyPathToName[\MyPlaylistDetailDependency.uploadDefaultPlaylistImageUseCase] = "uploadDefaultPlaylistImageUseCase-any UploadDefaultPlaylistImageUseCase"
        keyPathToName[\MyPlaylistDetailDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\MyPlaylistDetailDependency.multiPurposePopupFactory] = "multiPurposePopupFactory-any MultiPurposePopupFactory"
        keyPathToName[\MyPlaylistDetailDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\MyPlaylistDetailDependency.playlistCoverOptionPopupFactory] = "playlistCoverOptionPopupFactory-any PlaylistCoverOptionPopupFactory"
        keyPathToName[\MyPlaylistDetailDependency.checkPlaylistCoverFactory] = "checkPlaylistCoverFactory-any CheckPlaylistCoverFactory"
        keyPathToName[\MyPlaylistDetailDependency.defaultPlaylistCoverFactory] = "defaultPlaylistCoverFactory-any DefaultPlaylistCoverFactory"
        keyPathToName[\MyPlaylistDetailDependency.requestCustomImageURLUseCase] = "requestCustomImageURLUseCase-any RequestCustomImageURLUseCase"
        keyPathToName[\MyPlaylistDetailDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
        keyPathToName[\MyPlaylistDetailDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension DefaultPlaylistCoverComponent: Registration {
    public func registerItems() {
        keyPathToName[\DefaultPlaylistCoverDependency.fetchDefaultPlaylistImageUseCase] = "fetchDefaultPlaylistImageUseCase-any FetchDefaultPlaylistImageUseCase"
    }
}
@MainActor extension PlaylistComponent: Registration {
    public func registerItems() {
        keyPathToName[\PlaylistDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\PlaylistDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
        keyPathToName[\PlaylistDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\PlaylistDependency.signInFactory] = "signInFactory-any SignInFactory"
    }
}
@MainActor extension UnknownPlaylistDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\UnknownPlaylistDetailDependency.fetchPlaylistDetailUseCase] = "fetchPlaylistDetailUseCase-any FetchPlaylistDetailUseCase"
        keyPathToName[\UnknownPlaylistDetailDependency.subscribePlaylistUseCase] = "subscribePlaylistUseCase-any SubscribePlaylistUseCase"
        keyPathToName[\UnknownPlaylistDetailDependency.checkSubscriptionUseCase] = "checkSubscriptionUseCase-any CheckSubscriptionUseCase"
        keyPathToName[\UnknownPlaylistDetailDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\UnknownPlaylistDetailDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\UnknownPlaylistDetailDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
        keyPathToName[\UnknownPlaylistDetailDependency.signInFactory] = "signInFactory-any SignInFactory"
    }
}
@MainActor extension CheckPlaylistCoverComponent: Registration {
    public func registerItems() {
        keyPathToName[\CheckPlaylistCoverDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension FruitStorageComponent: Registration {
    public func registerItems() {
        keyPathToName[\FruitStorageDependency.fetchFruitListUseCase] = "fetchFruitListUseCase-any FetchFruitListUseCase"
        keyPathToName[\FruitStorageDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension FruitDrawComponent: Registration {
    public func registerItems() {
        keyPathToName[\FruitDrawDependency.fetchFruitDrawStatusUseCase] = "fetchFruitDrawStatusUseCase-any FetchFruitDrawStatusUseCase"
        keyPathToName[\FruitDrawDependency.drawFruitUseCase] = "drawFruitUseCase-any DrawFruitUseCase"
        keyPathToName[\FruitDrawDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension CreditSongListTabItemComponent: Registration {
    public func registerItems() {
        keyPathToName[\CreditSongListTabItemDependency.fetchCreditSongListUseCase] = "fetchCreditSongListUseCase-any FetchCreditSongListUseCase"
        keyPathToName[\CreditSongListTabItemDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\CreditSongListTabItemDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\CreditSongListTabItemDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\CreditSongListTabItemDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
    }
}
@MainActor extension CreditSongListTabComponent: Registration {
    public func registerItems() {
        keyPathToName[\CreditSongListTabDependency.creditSongListTabItemFactory] = "creditSongListTabItemFactory-any CreditSongListTabItemFactory"
    }
}
@MainActor extension CreditSongListComponent: Registration {
    public func registerItems() {
        keyPathToName[\CreditSongListDependency.creditSongListTabFactory] = "creditSongListTabFactory-any CreditSongListTabFactory"
        keyPathToName[\CreditSongListDependency.fetchCreditProfileUseCase] = "fetchCreditProfileUseCase-any FetchCreditProfileUseCase"
    }
}
@MainActor extension ChartComponent: Registration {
    public func registerItems() {
        keyPathToName[\ChartDependency.chartContentComponent] = "chartContentComponent-ChartContentComponent"
    }
}
@MainActor extension ChartContentComponent: Registration {
    public func registerItems() {
        keyPathToName[\ChartContentDependency.fetchChartRankingUseCase] = "fetchChartRankingUseCase-any FetchChartRankingUseCase"
        keyPathToName[\ChartContentDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\ChartContentDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\ChartContentDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\ChartContentDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
    }
}
@MainActor extension TeamInfoComponent: Registration {
    public func registerItems() {
        keyPathToName[\TeamInfoDependency.fetchTeamListUseCase] = "fetchTeamListUseCase-any FetchTeamListUseCase"
    }
}
@MainActor extension StorageComponent: Registration {
    public func registerItems() {
        keyPathToName[\StorageDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\StorageDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\StorageDependency.multiPurposePopupFactory] = "multiPurposePopupFactory-any MultiPurposePopupFactory"
        keyPathToName[\StorageDependency.listStorageComponent] = "listStorageComponent-ListStorageComponent"
        keyPathToName[\StorageDependency.likeStorageComponent] = "likeStorageComponent-LikeStorageComponent"
    }
}
@MainActor extension ListStorageComponent: Registration {
    public func registerItems() {
        keyPathToName[\ListStorageDependency.multiPurposePopupFactory] = "multiPurposePopupFactory-any MultiPurposePopupFactory"
        keyPathToName[\ListStorageDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
        keyPathToName[\ListStorageDependency.createPlaylistUseCase] = "createPlaylistUseCase-any CreatePlaylistUseCase"
        keyPathToName[\ListStorageDependency.editPlayListOrderUseCase] = "editPlayListOrderUseCase-any EditPlaylistOrderUseCase"
        keyPathToName[\ListStorageDependency.fetchPlayListUseCase] = "fetchPlayListUseCase-any FetchPlaylistUseCase"
        keyPathToName[\ListStorageDependency.deletePlayListUseCase] = "deletePlayListUseCase-any DeletePlaylistUseCase"
        keyPathToName[\ListStorageDependency.fetchPlaylistSongsUseCase] = "fetchPlaylistSongsUseCase-any FetchPlaylistSongsUseCase"
        keyPathToName[\ListStorageDependency.fetchPlaylistCreationPriceUseCase] = "fetchPlaylistCreationPriceUseCase-any FetchPlaylistCreationPriceUseCase"
        keyPathToName[\ListStorageDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\ListStorageDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\ListStorageDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\ListStorageDependency.fruitDrawFactory] = "fruitDrawFactory-any FruitDrawFactory"
    }
}
@MainActor extension LikeStorageComponent: Registration {
    public func registerItems() {
        keyPathToName[\LikeStorageDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\LikeStorageDependency.fetchFavoriteSongsUseCase] = "fetchFavoriteSongsUseCase-any FetchFavoriteSongsUseCase"
        keyPathToName[\LikeStorageDependency.editFavoriteSongsOrderUseCase] = "editFavoriteSongsOrderUseCase-any EditFavoriteSongsOrderUseCase"
        keyPathToName[\LikeStorageDependency.deleteFavoriteListUseCase] = "deleteFavoriteListUseCase-any DeleteFavoriteListUseCase"
        keyPathToName[\LikeStorageDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\LikeStorageDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\LikeStorageDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\LikeStorageDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
    }
}
@MainActor extension RootComponent: Registration {
    public func registerItems() {
        keyPathToName[\RootDependency.mainContainerComponent] = "mainContainerComponent-MainContainerComponent"
        keyPathToName[\RootDependency.permissionComponent] = "permissionComponent-PermissionComponent"
        keyPathToName[\RootDependency.fetchUserInfoUseCase] = "fetchUserInfoUseCase-any FetchUserInfoUseCase"
        keyPathToName[\RootDependency.fetchAppCheckUseCase] = "fetchAppCheckUseCase-any FetchAppCheckUseCase"
        keyPathToName[\RootDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\RootDependency.checkIsExistAccessTokenUseCase] = "checkIsExistAccessTokenUseCase-any CheckIsExistAccessTokenUseCase"
        keyPathToName[\RootDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension PermissionComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension SignInComponent: Registration {
    public func registerItems() {
        keyPathToName[\SignInDependency.fetchTokenUseCase] = "fetchTokenUseCase-any FetchTokenUseCase"
        keyPathToName[\SignInDependency.fetchUserInfoUseCase] = "fetchUserInfoUseCase-any FetchUserInfoUseCase"
    }
}
@MainActor extension NewSongsComponent: Registration {
    public func registerItems() {
        keyPathToName[\NewSongsDependency.newSongsContentComponent] = "newSongsContentComponent-NewSongsContentComponent"
    }
}
@MainActor extension HomeComponent: Registration {
    public func registerItems() {
        keyPathToName[\HomeDependency.fetchChartRankingUseCase] = "fetchChartRankingUseCase-any FetchChartRankingUseCase"
        keyPathToName[\HomeDependency.fetchNewSongsUseCase] = "fetchNewSongsUseCase-any FetchNewSongsUseCase"
        keyPathToName[\HomeDependency.fetchRecommendPlaylistUseCase] = "fetchRecommendPlaylistUseCase-any FetchRecommendPlaylistUseCase"
        keyPathToName[\HomeDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
        keyPathToName[\HomeDependency.chartFactory] = "chartFactory-any ChartFactory"
        keyPathToName[\HomeDependency.newSongsComponent] = "newSongsComponent-NewSongsComponent"
        keyPathToName[\HomeDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
    }
}
@MainActor extension NewSongsContentComponent: Registration {
    public func registerItems() {
        keyPathToName[\NewSongsContentDependency.fetchNewSongsUseCase] = "fetchNewSongsUseCase-any FetchNewSongsUseCase"
        keyPathToName[\NewSongsContentDependency.fetchNewSongsPlaylistUseCase] = "fetchNewSongsPlaylistUseCase-any FetchNewSongsPlaylistUseCase"
        keyPathToName[\NewSongsContentDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\NewSongsContentDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\NewSongsContentDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\NewSongsContentDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
    }
}
@MainActor extension WakmusicRecommendComponent: Registration {
    public func registerItems() {
        keyPathToName[\WakmusicRecommendDependency.fetchRecommendPlaylistUseCase] = "fetchRecommendPlaylistUseCase-any FetchRecommendPlaylistUseCase"
        keyPathToName[\WakmusicRecommendDependency.wakmusicPlaylistDetailFactory] = "wakmusicPlaylistDetailFactory-any WakmusicPlaylistDetailFactory"
    }
}
@MainActor extension BeforeSearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\BeforeSearchDependency.fetchRecommendPlaylistUseCase] = "fetchRecommendPlaylistUseCase-any FetchRecommendPlaylistUseCase"
        keyPathToName[\BeforeSearchDependency.fetchCurrentVideoUseCase] = "fetchCurrentVideoUseCase-any FetchCurrentVideoUseCase"
        keyPathToName[\BeforeSearchDependency.wakmusicRecommendComponent] = "wakmusicRecommendComponent-WakmusicRecommendComponent"
        keyPathToName[\BeforeSearchDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\BeforeSearchDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
    }
}
@MainActor extension SearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\SearchDependency.beforeSearchComponent] = "beforeSearchComponent-BeforeSearchComponent"
        keyPathToName[\SearchDependency.afterSearchComponent] = "afterSearchComponent-AfterSearchComponent"
        keyPathToName[\SearchDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\SearchDependency.searchGlobalScrollState] = "searchGlobalScrollState-any SearchGlobalScrollProtocol"
    }
}
@MainActor extension AfterSearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\AfterSearchDependency.songSearchResultFactory] = "songSearchResultFactory-any SongSearchResultFactory"
        keyPathToName[\AfterSearchDependency.listSearchResultFactory] = "listSearchResultFactory-any ListSearchResultFactory"
        keyPathToName[\AfterSearchDependency.searchGlobalScrollState] = "searchGlobalScrollState-any SearchGlobalScrollProtocol"
    }
}
@MainActor extension ListSearchResultComponent: Registration {
    public func registerItems() {
        keyPathToName[\ListSearchResultDependency.fetchSearchPlaylistsUseCase] = "fetchSearchPlaylistsUseCase-any FetchSearchPlaylistsUseCase"
        keyPathToName[\ListSearchResultDependency.searchSortOptionComponent] = "searchSortOptionComponent-SearchSortOptionComponent"
        keyPathToName[\ListSearchResultDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
        keyPathToName[\ListSearchResultDependency.searchGlobalScrollState] = "searchGlobalScrollState-any SearchGlobalScrollProtocol"
    }
}
@MainActor extension SongSearchResultComponent: Registration {
    public func registerItems() {
        keyPathToName[\SongSearchResultDependency.fetchSearchSongsUseCase] = "fetchSearchSongsUseCase-any FetchSearchSongsUseCase"
        keyPathToName[\SongSearchResultDependency.searchSortOptionComponent] = "searchSortOptionComponent-SearchSortOptionComponent"
        keyPathToName[\SongSearchResultDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\SongSearchResultDependency.searchGlobalScrollState] = "searchGlobalScrollState-any SearchGlobalScrollProtocol"
        keyPathToName[\SongSearchResultDependency.songDetailPresenter] = "songDetailPresenter-any SongDetailPresentable"
        keyPathToName[\SongSearchResultDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\SongSearchResultDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension SearchSortOptionComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension ContainSongsComponent: Registration {
    public func registerItems() {
        keyPathToName[\ContainSongsDependency.multiPurposePopupFactory] = "multiPurposePopupFactory-any MultiPurposePopupFactory"
        keyPathToName[\ContainSongsDependency.fetchPlayListUseCase] = "fetchPlayListUseCase-any FetchPlaylistUseCase"
        keyPathToName[\ContainSongsDependency.addSongIntoPlaylistUseCase] = "addSongIntoPlaylistUseCase-any AddSongIntoPlaylistUseCase"
        keyPathToName[\ContainSongsDependency.createPlaylistUseCase] = "createPlaylistUseCase-any CreatePlaylistUseCase"
        keyPathToName[\ContainSongsDependency.fetchPlaylistCreationPriceUseCase] = "fetchPlaylistCreationPriceUseCase-any FetchPlaylistCreationPriceUseCase"
        keyPathToName[\ContainSongsDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\ContainSongsDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
    }
}
@MainActor extension MultiPurposePopupComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension TextPopupComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension ServiceTermsComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension PrivacyComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension ServiceInfoComponent: Registration {
    public func registerItems() {
        keyPathToName[\ServiceInfoDependency.openSourceLicenseFactory] = "openSourceLicenseFactory-any OpenSourceLicenseFactory"
        keyPathToName[\ServiceInfoDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension PlayTypeTogglePopupComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension FaqComponent: Registration {
    public func registerItems() {
        keyPathToName[\FaqDependency.faqContentFactory] = "faqContentFactory-any FaqContentFactory"
        keyPathToName[\FaqDependency.fetchFaqCategoriesUseCase] = "fetchFaqCategoriesUseCase-any FetchFaqCategoriesUseCase"
        keyPathToName[\FaqDependency.fetchFaqUseCase] = "fetchFaqUseCase-any FetchFaqUseCase"
    }
}
@MainActor extension QuestionComponent: Registration {
    public func registerItems() {
        keyPathToName[\QuestionDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
    }
}
@MainActor extension MyInfoComponent: Registration {
    public func registerItems() {
        keyPathToName[\MyInfoDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\MyInfoDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\MyInfoDependency.multiPurposePopupFactory] = "multiPurposePopupFactory-any MultiPurposePopupFactory"
        keyPathToName[\MyInfoDependency.faqFactory] = "faqFactory-any FaqFactory"
        keyPathToName[\MyInfoDependency.noticeFactory] = "noticeFactory-any NoticeFactory"
        keyPathToName[\MyInfoDependency.questionFactory] = "questionFactory-any QuestionFactory"
        keyPathToName[\MyInfoDependency.teamInfoFactory] = "teamInfoFactory-any TeamInfoFactory"
        keyPathToName[\MyInfoDependency.settingFactory] = "settingFactory-any SettingFactory"
        keyPathToName[\MyInfoDependency.profilePopupFactory] = "profilePopupFactory-any ProfilePopupFactory"
        keyPathToName[\MyInfoDependency.fruitDrawFactory] = "fruitDrawFactory-any FruitDrawFactory"
        keyPathToName[\MyInfoDependency.fruitStorageFactory] = "fruitStorageFactory-any FruitStorageFactory"
        keyPathToName[\MyInfoDependency.fetchNoticeIDListUseCase] = "fetchNoticeIDListUseCase-any FetchNoticeIDListUseCase"
        keyPathToName[\MyInfoDependency.setUserNameUseCase] = "setUserNameUseCase-any SetUserNameUseCase"
        keyPathToName[\MyInfoDependency.fetchUserInfoUseCase] = "fetchUserInfoUseCase-any FetchUserInfoUseCase"
    }
}
@MainActor extension SettingComponent: Registration {
    public func registerItems() {
        keyPathToName[\SettingDependency.withdrawUserInfoUseCase] = "withdrawUserInfoUseCase-any WithdrawUserInfoUseCase"
        keyPathToName[\SettingDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\SettingDependency.updateNotificationTokenUseCase] = "updateNotificationTokenUseCase-any UpdateNotificationTokenUseCase"
        keyPathToName[\SettingDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\SettingDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\SettingDependency.serviceTermsFactory] = "serviceTermsFactory-any ServiceTermFactory"
        keyPathToName[\SettingDependency.privacyFactory] = "privacyFactory-any PrivacyFactory"
        keyPathToName[\SettingDependency.openSourceLicenseFactory] = "openSourceLicenseFactory-any OpenSourceLicenseFactory"
        keyPathToName[\SettingDependency.playTypeTogglePopupFactory] = "playTypeTogglePopupFactory-any PlayTypeTogglePopupFactory"
    }
}
@MainActor extension NoticeDetailComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension ProfilePopupComponent: Registration {
    public func registerItems() {
        keyPathToName[\ProfilePopupDependency.fetchProfileListUseCase] = "fetchProfileListUseCase-any FetchProfileListUseCase"
        keyPathToName[\ProfilePopupDependency.setProfileUseCase] = "setProfileUseCase-any SetProfileUseCase"
    }
}
@MainActor extension OpenSourceLicenseComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension NoticeComponent: Registration {
    public func registerItems() {
        keyPathToName[\NoticeDependency.fetchNoticeAllUseCase] = "fetchNoticeAllUseCase-any FetchNoticeAllUseCase"
        keyPathToName[\NoticeDependency.noticeDetailFactory] = "noticeDetailFactory-any NoticeDetailFactory"
    }
}
@MainActor extension FaqContentComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension SongCreditComponent: Registration {
    public func registerItems() {
        keyPathToName[\SongCreditDependency.fetchSongCreditsUseCase] = "fetchSongCreditsUseCase-any FetchSongCreditsUseCase"
        keyPathToName[\SongCreditDependency.creditSongListFactory] = "creditSongListFactory-any CreditSongListFactory"
        keyPathToName[\SongCreditDependency.artistDetailFactory] = "artistDetailFactory-any ArtistDetailFactory"
    }
}
@MainActor extension KaraokeComponent: Registration {
    public func registerItems() {

    }
}
@MainActor extension MusicDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\MusicDetailDependency.fetchSongUseCase] = "fetchSongUseCase-any FetchSongUseCase"
        keyPathToName[\MusicDetailDependency.lyricHighlightingFactory] = "lyricHighlightingFactory-any LyricHighlightingFactory"
        keyPathToName[\MusicDetailDependency.songCreditFactory] = "songCreditFactory-any SongCreditFactory"
        keyPathToName[\MusicDetailDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\MusicDetailDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\MusicDetailDependency.karaokeFactory] = "karaokeFactory-any KaraokeFactory"
        keyPathToName[\MusicDetailDependency.textPopupFactory] = "textPopupFactory-any TextPopupFactory"
        keyPathToName[\MusicDetailDependency.artistDetailFactory] = "artistDetailFactory-any ArtistDetailFactory"
        keyPathToName[\MusicDetailDependency.playlistPresenterGlobalState] = "playlistPresenterGlobalState-any PlayListPresenterGlobalStateProtocol"
        keyPathToName[\MusicDetailDependency.addLikeSongUseCase] = "addLikeSongUseCase-any AddLikeSongUseCase"
        keyPathToName[\MusicDetailDependency.cancelLikeSongUseCase] = "cancelLikeSongUseCase-any CancelLikeSongUseCase"
        keyPathToName[\MusicDetailDependency.findArtistIDUseCase] = "findArtistIDUseCase-any FindArtistIDUseCase"
    }
}


#endif

@MainActor private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
@MainActor
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@MainActor
@inline(never) private func register1() {
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->ArtistComponent", factorye0c5444f5894148bdd93f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ArtistDetailComponent", factory35314797fadaf164ece6f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ArtistMusicContentComponent", factory8b6ffa46033e2529b5daf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ArtistMusicComponent", factory382e7f8466df35a3f1d9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->LyricHighlightingComponent", factory57ee59e468bef412b173f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->LyricDecoratingComponent", factory5d05db9eb4337d682097f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->MainTabBarComponent", factorye547a52b3fce5887c8c7f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->BottomTabBarComponent", factoryd34fa9e493604a6295bde3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->MainContainerComponent", factory8e19f48d5d573d3ea539f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NoticePopupComponent", factorycd081aacb61d6a707ca7e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->PlaylistCoverOptionPopupComponent", factory487946b77daee32980aff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PlaylistDetailComponent", factory6595408565b754d9f0f7f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->WakmusicPlaylistDetailComponent", factorye3e053cabf65749566c8f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->MyPlaylistDetailComponent", factoryc6efd92ea498eaae7ff8f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->DefaultPlaylistCoverComponent", factory89371387a9e4c131e13df47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PlaylistComponent", factory3a0a6eb1061d8d5a2deff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->UnknownPlaylistDetailComponent", factorya6d30d5b4471815dceb2f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->CheckPlaylistCoverComponent", factory025ce9f6d91409a9f719f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->FruitStorageComponent", factory070e42b0224381c8cdf4f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->FruitDrawComponent", factoryc603eb682d7a111dc261f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->CreditSongListTabItemComponent", factory95828465b02bfed94ec5f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->CreditSongListTabComponent", factory85beabbf7f1f193dec41f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->CreditSongListComponent", factorye0caf4db37d0954ab34ef47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ChartComponent", factoryeac6a4df54bbd391d31bf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ChartContentComponent", factoryc9a137630ce76907f36ff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->TeamInfoComponent", factorybe60e92b5190e00abf41f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->StorageComponent", factory2415399d25299b97b98bf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ListStorageComponent", factory75c66cb7534f04d45951f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->LikeStorageComponent", factory9f7222d7c56236b2e993f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->RootComponent", factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PermissionComponent", factoryc1d4d80afbccf86bf1c0e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->SignInComponent", factoryda2925fd76da866a652af47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NewSongsComponent", factory379179b05dd24ff979edf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent", factory67229cdf0f755562b2b1f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NewSongsContentComponent", factorye130e1fbfcbc622a4c38f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->WakmusicRecommendComponent", factoryaf1c3535530356714983f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->BeforeSearchComponent", factory9bb852337d5550979293f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SearchComponent", factorye3d049458b2ccbbcb3b6f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AfterSearchComponent", factoryeb2da679e35e2c4fb9a5f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ListSearchResultComponent", factory2c8e2a50d1fcf9efc9f8f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SongSearchResultComponent", factory182af2382ca6172f89c1f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SearchSortOptionComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->ContainSongsComponent", factory4d4f4455414271fee232f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->MultiPurposePopupComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->TextPopupComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->ServiceTermsComponent", factory8014909e2d8dba4e4f20e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->PrivacyComponent", factorye7f5d59533cfdd1614b0e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->ServiceInfoComponent", factory3afd170b9974b0dbd863f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PlayTypeTogglePopupComponent", factoryEmptyDependencyProvider)
}

@MainActor
@inline(never) private func register2() {
    registerProviderFactory("^->AppComponent->FaqComponent", factory4e13cc6545633ffc2ed5f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->QuestionComponent", factoryedad1813a36115eec11ef47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->MyInfoComponent", factoryec2cede3edc2a626b35df47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SettingComponent", factoryee0bbc0b920a7007e1a9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NoticeDetailComponent", factory3db143c2f80d621d5a7fe3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->ProfilePopupComponent", factory3a1ad3396729bed7200ef47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->OpenSourceLicenseComponent", factoryd505894818021731340ae3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->NoticeComponent", factoryaf8e5665e5b9217918f5f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->FaqContentComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->SongCreditComponent", factoryd48a3e0e81529a27a02bf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->KaraokeComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->MusicDetailComponent", factory84f307443e9a78802606f47b58f8f304c97af4d5)
}
#endif

@MainActor
public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
    register2()
#endif
}
