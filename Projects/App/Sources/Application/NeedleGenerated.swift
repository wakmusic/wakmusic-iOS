

import AppDomain
import AppDomainInterface
import ArtistDomain
import ArtistDomainInterface
import ArtistFeature
import AuthDomain
import AuthDomainInterface
import BaseDomainInterface
import BaseFeature
import BaseFeatureInterface
import ChartDomain
import ChartDomainInterface
import ChartFeature
import FaqDomain
import FaqDomainInterface
import Foundation
import HomeFeature
import KeychainModule
import LikeDomain
import LikeDomainInterface
import LyricHighlightingFeature
import LyricHighlightingFeatureInterface
import MainTabFeature
import MyInfoFeature
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomain
import NoticeDomainInterface
import PlayListDomain
import PlayListDomainInterface
import PlayerFeature
import PlaylistFeature
import PlaylistFeatureInterface
import RootFeature
import SearchFeature
import SearchFeatureInterface
import SignInFeature
import SignInFeatureInterface
import SongsDomain
import SongsDomainInterface
import StorageFeature
import StorageFeatureInterface
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

private class ArtistDependency132a213bf62ad60c622cProvider: ArtistDependency {
    var fetchArtistListUseCase: any FetchArtistListUseCase {
        return appComponent.fetchArtistListUseCase
    }
    var artistDetailComponent: ArtistDetailComponent {
        return appComponent.artistDetailComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistComponent
private func factorye0c5444f5894148bdd93f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistDependency132a213bf62ad60c622cProvider(appComponent: parent1(component) as! AppComponent)
}
private class ArtistDetailDependencyee413dcf7a70e89df6d9Provider: ArtistDetailDependency {
    var artistMusicComponent: ArtistMusicComponent {
        return appComponent.artistMusicComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistDetailComponent
private func factory35314797fadaf164ece6f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistDetailDependencyee413dcf7a70e89df6d9Provider(appComponent: parent1(component) as! AppComponent)
}
private class ArtistMusicContentDependency1615ac8469e54ec51921Provider: ArtistMusicContentDependency {
    var fetchArtistSongListUseCase: any FetchArtistSongListUseCase {
        return appComponent.fetchArtistSongListUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistMusicContentComponent
private func factory8b6ffa46033e2529b5daf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistMusicContentDependency1615ac8469e54ec51921Provider(appComponent: parent1(component) as! AppComponent)
}
private class ArtistMusicDependencya0f5073287829dfbc260Provider: ArtistMusicDependency {
    var artistMusicContentComponent: ArtistMusicContentComponent {
        return appComponent.artistMusicContentComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ArtistMusicComponent
private func factory382e7f8466df35a3f1d9f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ArtistMusicDependencya0f5073287829dfbc260Provider(appComponent: parent1(component) as! AppComponent)
}
private class PlaylistDependency6f376d117dc0f38671edProvider: PlaylistDependency {
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->PlaylistComponent
private func factory3a0a6eb1061d8d5a2deff47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlaylistDependency6f376d117dc0f38671edProvider(appComponent: parent1(component) as! AppComponent)
}
private class PlayerDependencyf8a3d594cc3b9254f8adProvider: PlayerDependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase {
        return appComponent.fetchLyricsUseCase
    }
    var addLikeSongUseCase: any AddLikeSongUseCase {
        return appComponent.addLikeSongUseCase
    }
    var cancelLikeSongUseCase: any CancelLikeSongUseCase {
        return appComponent.cancelLikeSongUseCase
    }
    var fetchLikeNumOfSongUseCase: any FetchLikeNumOfSongUseCase {
        return appComponent.fetchLikeNumOfSongUseCase
    }
    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase {
        return appComponent.fetchFavoriteSongsUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var playlistComponent: PlaylistComponent {
        return appComponent.playlistComponent
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->PlayerComponent
private func factorybc7f802f601dd5913533f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlayerDependencyf8a3d594cc3b9254f8adProvider(appComponent: parent1(component) as! AppComponent)
}
private class LyricHighlightingDependency47c68b56cdde819901d2Provider: LyricHighlightingDependency {
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
private func factory57ee59e468bef412b173f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LyricHighlightingDependency47c68b56cdde819901d2Provider(appComponent: parent1(component) as! AppComponent)
}
private class LyricDecoratingDependencya7e8bf6f2f4ae447ba4eProvider: LyricDecoratingDependency {


    init() {

    }
}
/// ^->AppComponent->LyricDecoratingComponent
private func factory5d05db9eb4337d682097e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LyricDecoratingDependencya7e8bf6f2f4ae447ba4eProvider()
}
private class MainTabBarDependencycd05b79389a6a7a6c20fProvider: MainTabBarDependency {
    var fetchNoticeUseCase: any FetchNoticeUseCase {
        return appComponent.fetchNoticeUseCase
    }
    var homeComponent: HomeComponent {
        return appComponent.homeComponent
    }
    var chartComponent: ChartComponent {
        return appComponent.chartComponent
    }
    var searchFactory: any SearchFactory {
        return appComponent.searchFactory
    }
    var artistComponent: ArtistComponent {
        return appComponent.artistComponent
    }
    var storageFactory: any StorageFactory {
        return appComponent.storageFactory
    }
    var myInfoComponent: MyInfoComponent {
        return appComponent.myInfoComponent
    }
    var noticePopupComponent: NoticePopupComponent {
        return appComponent.noticePopupComponent
    }
    var noticeComponent: NoticeComponent {
        return appComponent.noticeComponent
    }
    var noticeDetailComponent: NoticeDetailComponent {
        return appComponent.noticeDetailComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MainTabBarComponent
private func factorye547a52b3fce5887c8c7f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainTabBarDependencycd05b79389a6a7a6c20fProvider(appComponent: parent1(component) as! AppComponent)
}
private class BottomTabBarDependency237c2bd1c7be62020295Provider: BottomTabBarDependency {


    init() {

    }
}
/// ^->AppComponent->BottomTabBarComponent
private func factoryd34fa9e493604a6295bde3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return BottomTabBarDependency237c2bd1c7be62020295Provider()
}
private class MainContainerDependencyd9d908a1d0cf8937bbadProvider: MainContainerDependency {
    var bottomTabBarComponent: BottomTabBarComponent {
        return appComponent.bottomTabBarComponent
    }
    var mainTabBarComponent: MainTabBarComponent {
        return appComponent.mainTabBarComponent
    }
    var playerComponent: PlayerComponent {
        return appComponent.playerComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MainContainerComponent
private func factory8e19f48d5d573d3ea539f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainContainerDependencyd9d908a1d0cf8937bbadProvider(appComponent: parent1(component) as! AppComponent)
}
private class NoticePopupDependency579e3504f53119c2eef1Provider: NoticePopupDependency {


    init() {

    }
}
/// ^->AppComponent->NoticePopupComponent
private func factorycd081aacb61d6a707ca7e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NoticePopupDependency579e3504f53119c2eef1Provider()
}
private class PlayListDetailDependencyb06fb5392859952b82a2Provider: PlayListDetailDependency {
    var fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase {
        return appComponent.fetchPlayListDetailUseCase
    }
    var updatePlaylistUseCase: any UpdatePlaylistUseCase {
        return appComponent.updatePlaylistUseCase
    }
    var removeSongsUseCase: any RemoveSongsUseCase {
        return appComponent.removeSongsUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory {
        return appComponent.multiPurposePopUpFactory
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->PlayListDetailComponent
private func factory9e077ee814ce180ea399f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlayListDetailDependencyb06fb5392859952b82a2Provider(appComponent: parent1(component) as! AppComponent)
}
private class ChartDependencyafd8882010751c9ef054Provider: ChartDependency {
    var chartContentComponent: ChartContentComponent {
        return appComponent.chartContentComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ChartComponent
private func factoryeac6a4df54bbd391d31bf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ChartDependencyafd8882010751c9ef054Provider(appComponent: parent1(component) as! AppComponent)
}
private class ChartContentDependency3b8e41cfba060e4d16caProvider: ChartContentDependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase {
        return appComponent.fetchChartRankingUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ChartContentComponent
private func factoryc9a137630ce76907f36ff47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ChartContentDependency3b8e41cfba060e4d16caProvider(appComponent: parent1(component) as! AppComponent)
}
private class StorageDependency1447167c38e97ef97427Provider: StorageDependency {
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var myPlayListComponent: MyPlayListComponent {
        return appComponent.myPlayListComponent
    }
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory {
        return appComponent.multiPurposePopUpFactory
    }
    var favoriteComponent: FavoriteComponent {
        return appComponent.favoriteComponent
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->StorageComponent
private func factory2415399d25299b97b98bf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return StorageDependency1447167c38e97ef97427Provider(appComponent: parent1(component) as! AppComponent)
}
private class MyPlayListDependency067bbf42b28f80e413acProvider: MyPlayListDependency {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory {
        return appComponent.multiPurposePopUpFactory
    }
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    var fetchPlayListUseCase: any FetchPlayListUseCase {
        return appComponent.fetchPlayListUseCase
    }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase {
        return appComponent.editPlayListOrderUseCase
    }
    var deletePlayListUseCase: any DeletePlayListUseCase {
        return appComponent.deletePlayListUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MyPlayListComponent
private func factory51a57a92f76af93a9ec2f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MyPlayListDependency067bbf42b28f80e413acProvider(appComponent: parent1(component) as! AppComponent)
}
private class FavoriteDependency8f7fd37aeb6f0e5d0e30Provider: FavoriteDependency {
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
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->FavoriteComponent
private func factory8e4acb90bd0d9b48604af47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return FavoriteDependency8f7fd37aeb6f0e5d0e30Provider(appComponent: parent1(component) as! AppComponent)
}
private class ProfilePopDependency081172e20caa75abdb54Provider: ProfilePopDependency {
    var fetchProfileListUseCase: any FetchProfileListUseCase {
        return appComponent.fetchProfileListUseCase
    }
    var setProfileUseCase: any SetProfileUseCase {
        return appComponent.setProfileUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ProfilePopComponent
private func factorybd14b11ccce6dac94a24f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ProfilePopDependency081172e20caa75abdb54Provider(appComponent: parent1(component) as! AppComponent)
}
private class RootDependency3944cc797a4a88956fb5Provider: RootDependency {
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
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->RootComponent
private func factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RootDependency3944cc797a4a88956fb5Provider(appComponent: parent1(component) as! AppComponent)
}
private class PermissionDependency517ed7598d8c08817d14Provider: PermissionDependency {


    init() {

    }
}
/// ^->AppComponent->PermissionComponent
private func factoryc1d4d80afbccf86bf1c0e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PermissionDependency517ed7598d8c08817d14Provider()
}
private class SignInDependency5dda0dd015447272446cProvider: SignInDependency {
    var fetchTokenUseCase: any FetchTokenUseCase {
        return appComponent.fetchTokenUseCase
    }
    var fetchNaverUserInfoUseCase: any FetchNaverUserInfoUseCase {
        return appComponent.fetchNaverUserInfoUseCase
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
private func factoryda2925fd76da866a652af47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SignInDependency5dda0dd015447272446cProvider(appComponent: parent1(component) as! AppComponent)
}
private class NewSongsDependencyee634cc0cae21fc2a9e3Provider: NewSongsDependency {
    var newSongsContentComponent: NewSongsContentComponent {
        return appComponent.newSongsContentComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->NewSongsComponent
private func factory379179b05dd24ff979edf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NewSongsDependencyee634cc0cae21fc2a9e3Provider(appComponent: parent1(component) as! AppComponent)
}
private class HomeDependency443c4e1871277bd8432aProvider: HomeDependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase {
        return appComponent.fetchChartRankingUseCase
    }
    var fetchNewSongsUseCase: any FetchNewSongsUseCase {
        return appComponent.fetchNewSongsUseCase
    }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase {
        return appComponent.fetchRecommendPlayListUseCase
    }
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    var newSongsComponent: NewSongsComponent {
        return appComponent.newSongsComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->HomeComponent
private func factory67229cdf0f755562b2b1f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return HomeDependency443c4e1871277bd8432aProvider(appComponent: parent1(component) as! AppComponent)
}
private class NewSongsContentDependency93a05f20fa300c5bbec3Provider: NewSongsContentDependency {
    var fetchNewSongsUseCase: any FetchNewSongsUseCase {
        return appComponent.fetchNewSongsUseCase
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->NewSongsContentComponent
private func factorye130e1fbfcbc622a4c38f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NewSongsContentDependency93a05f20fa300c5bbec3Provider(appComponent: parent1(component) as! AppComponent)
}
private class AfterSearchDependency61822c19bc2eb46d7c52Provider: AfterSearchDependency {
    var songSearchResultFactory: any SongSearchResultFactory {
        return appComponent.songSearchResultFactory
    }
    var containSongsFactory: any ContainSongsFactory {
        return appComponent.containSongsFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AfterSearchComponent
private func factoryeb2da679e35e2c4fb9a5f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AfterSearchDependency61822c19bc2eb46d7c52Provider(appComponent: parent1(component) as! AppComponent)
}
private class SearchDependencya86903a2c751a4f762e8Provider: SearchDependency {
    var beforeSearchComponent: BeforeSearchComponent {
        return appComponent.beforeSearchComponent
    }
    var afterSearchComponent: AfterSearchComponent {
        return appComponent.afterSearchComponent
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SearchComponent
private func factorye3d049458b2ccbbcb3b6f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SearchDependencya86903a2c751a4f762e8Provider(appComponent: parent1(component) as! AppComponent)
}
private class BeforeSearchDependencyebdecb1d478a4766488dProvider: BeforeSearchDependency {
    var playlistDetailFactory: any PlaylistDetailFactory {
        return appComponent.playlistDetailFactory
    }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase {
        return appComponent.fetchRecommendPlayListUseCase
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->BeforeSearchComponent
private func factory9bb852337d5550979293f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return BeforeSearchDependencyebdecb1d478a4766488dProvider(appComponent: parent1(component) as! AppComponent)
}
private class ContainSongsDependencydbd9ae8a072db3a22630Provider: ContainSongsDependency {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory {
        return appComponent.multiPurposePopUpFactory
    }
    var fetchPlayListUseCase: any FetchPlayListUseCase {
        return appComponent.fetchPlayListUseCase
    }
    var addSongIntoPlayListUseCase: any AddSongIntoPlayListUseCase {
        return appComponent.addSongIntoPlayListUseCase
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
private func factory4d4f4455414271fee232f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ContainSongsDependencydbd9ae8a072db3a22630Provider(appComponent: parent1(component) as! AppComponent)
}
private class MultiPurposePopUpDependencyfb7ce9f5d0057e8159d7Provider: MultiPurposePopUpDependency {
    var createPlayListUseCase: any CreatePlayListUseCase {
        return appComponent.createPlayListUseCase
    }
    var setUserNameUseCase: any SetUserNameUseCase {
        return appComponent.setUserNameUseCase
    }
    var updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase {
        return appComponent.updateTitleAndPrivateUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MultiPurposePopUpComponent
private func factorya77269be267fb568bd4ff47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MultiPurposePopUpDependencyfb7ce9f5d0057e8159d7Provider(appComponent: parent1(component) as! AppComponent)
}
private class ServiceTermsDependencyd07df8dc0771e5580b47Provider: ServiceTermsDependency {


    init() {

    }
}
/// ^->AppComponent->ServiceTermsComponent
private func factory8014909e2d8dba4e4f20e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ServiceTermsDependencyd07df8dc0771e5580b47Provider()
}
private class PrivacyDependency51c6df0186843bf53e9cProvider: PrivacyDependency {


    init() {

    }
}
/// ^->AppComponent->PrivacyComponent
private func factorye7f5d59533cfdd1614b0e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PrivacyDependency51c6df0186843bf53e9cProvider()
}
private class ServiceInfoDependency17ccca17be0fc87c9a2eProvider: ServiceInfoDependency {
    var openSourceLicenseComponent: OpenSourceLicenseComponent {
        return appComponent.openSourceLicenseComponent
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->ServiceInfoComponent
private func factory3afd170b9974b0dbd863f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ServiceInfoDependency17ccca17be0fc87c9a2eProvider(appComponent: parent1(component) as! AppComponent)
}
private class FaqDependency899aad15f17210a3af31Provider: FaqDependency {
    var faqContentComponent: FaqContentComponent {
        return appComponent.faqContentComponent
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
private func factory4e13cc6545633ffc2ed5f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return FaqDependency899aad15f17210a3af31Provider(appComponent: parent1(component) as! AppComponent)
}
private class QuestionDependencyf7010567c2d88e76d191Provider: QuestionDependency {
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->QuestionComponent
private func factoryedad1813a36115eec11ef47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return QuestionDependencyf7010567c2d88e76d191Provider(appComponent: parent1(component) as! AppComponent)
}
private class MyInfoDependency3b44bce00dab6fc2e345Provider: MyInfoDependency {
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    var faqComponent: FaqComponent {
        return appComponent.faqComponent
    }
    var noticeComponent: NoticeComponent {
        return appComponent.noticeComponent
    }
    var questionComponent: QuestionComponent {
        return appComponent.questionComponent
    }
    var teamInfoComponent: TeamInfoComponent {
        return appComponent.teamInfoComponent
    }
    var settingComponent: SettingComponent {
        return appComponent.settingComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MyInfoComponent
private func factoryec2cede3edc2a626b35df47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MyInfoDependency3b44bce00dab6fc2e345Provider(appComponent: parent1(component) as! AppComponent)
}
private class SettingDependency792c9caceb5cb097fbecProvider: SettingDependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase {
        return appComponent.withdrawUserInfoUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    var signInFactory: any SignInFactory {
        return appComponent.signInFactory
    }
    var appPushSettingComponent: AppPushSettingComponent {
        return appComponent.appPushSettingComponent
    }
    var serviceTermsComponent: ServiceTermsComponent {
        return appComponent.serviceTermsComponent
    }
    var privacyComponent: PrivacyComponent {
        return appComponent.privacyComponent
    }
    var openSourceLicenseComponent: OpenSourceLicenseComponent {
        return appComponent.openSourceLicenseComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SettingComponent
private func factoryee0bbc0b920a7007e1a9f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SettingDependency792c9caceb5cb097fbecProvider(appComponent: parent1(component) as! AppComponent)
}
private class RequestDependencyd4f6f0030dbf2a90cf21Provider: RequestDependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase {
        return appComponent.withdrawUserInfoUseCase
    }
    var logoutUseCase: any LogoutUseCase {
        return appComponent.logoutUseCase
    }
    var faqComponent: FaqComponent {
        return appComponent.faqComponent
    }
    var questionComponent: QuestionComponent {
        return appComponent.questionComponent
    }
    var noticeComponent: NoticeComponent {
        return appComponent.noticeComponent
    }
    var serviceInfoComponent: ServiceInfoComponent {
        return appComponent.serviceInfoComponent
    }
    var textPopUpFactory: any TextPopUpFactory {
        return appComponent.textPopUpFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->RequestComponent
private func factory13954fb3ec537bab80bcf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RequestDependencyd4f6f0030dbf2a90cf21Provider(appComponent: parent1(component) as! AppComponent)
}
private class AppPushSettingDependency349ed4aa80d55fc2a148Provider: AppPushSettingDependency {


    init() {

    }
}
/// ^->AppComponent->AppPushSettingComponent
private func factory0fbf44459a0855a29e8be3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AppPushSettingDependency349ed4aa80d55fc2a148Provider()
}
private class NoticeDetailDependency714af3aed40eaebda420Provider: NoticeDetailDependency {


    init() {

    }
}
/// ^->AppComponent->NoticeDetailComponent
private func factory3db143c2f80d621d5a7fe3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NoticeDetailDependency714af3aed40eaebda420Provider()
}
private class OpenSourceLicenseDependencyb6842dcc36b26380b91aProvider: OpenSourceLicenseDependency {


    init() {

    }
}
/// ^->AppComponent->OpenSourceLicenseComponent
private func factoryd505894818021731340ae3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OpenSourceLicenseDependencyb6842dcc36b26380b91aProvider()
}
private class NoticeDependencyaec92ef53617a421bdf3Provider: NoticeDependency {
    var fetchNoticeUseCase: any FetchNoticeUseCase {
        return appComponent.fetchNoticeUseCase
    }
    var noticeDetailComponent: NoticeDetailComponent {
        return appComponent.noticeDetailComponent
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->NoticeComponent
private func factoryaf8e5665e5b9217918f5f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NoticeDependencyaec92ef53617a421bdf3Provider(appComponent: parent1(component) as! AppComponent)
}
private class TeamInfoDependency94c25b4e5acfbc37741cProvider: TeamInfoDependency {


    init() {

    }
}
/// ^->AppComponent->TeamInfoComponent
private func factorybe60e92b5190e00abf41e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return TeamInfoDependency94c25b4e5acfbc37741cProvider()
}

#else
extension AppComponent: Registration {
    public func registerItems() {

        localTable["keychain-any Keychain"] = { [unowned self] in self.keychain as Any }
        localTable["homeComponent-HomeComponent"] = { [unowned self] in self.homeComponent as Any }
        localTable["newSongsComponent-NewSongsComponent"] = { [unowned self] in self.newSongsComponent as Any }
        localTable["newSongsContentComponent-NewSongsContentComponent"] = { [unowned self] in self.newSongsContentComponent as Any }
        localTable["lyricHighlightingFactory-any LyricHighlightingFactory"] = { [unowned self] in self.lyricHighlightingFactory as Any }
        localTable["lyricDecoratingComponent-LyricDecoratingComponent"] = { [unowned self] in self.lyricDecoratingComponent as Any }
        localTable["remoteSongsDataSource-any RemoteSongsDataSource"] = { [unowned self] in self.remoteSongsDataSource as Any }
        localTable["songsRepository-any SongsRepository"] = { [unowned self] in self.songsRepository as Any }
        localTable["fetchLyricsUseCase-any FetchLyricsUseCase"] = { [unowned self] in self.fetchLyricsUseCase as Any }
        localTable["fetchNewSongsUseCase-any FetchNewSongsUseCase"] = { [unowned self] in self.fetchNewSongsUseCase as Any }
        localTable["signInFactory-any SignInFactory"] = { [unowned self] in self.signInFactory as Any }
        localTable["storageFactory-any StorageFactory"] = { [unowned self] in self.storageFactory as Any }
        localTable["requestComponent-RequestComponent"] = { [unowned self] in self.requestComponent as Any }
        localTable["localAuthDataSource-any LocalAuthDataSource"] = { [unowned self] in self.localAuthDataSource as Any }
        localTable["remoteAuthDataSource-any RemoteAuthDataSource"] = { [unowned self] in self.remoteAuthDataSource as Any }
        localTable["authRepository-any AuthRepository"] = { [unowned self] in self.authRepository as Any }
        localTable["fetchTokenUseCase-any FetchTokenUseCase"] = { [unowned self] in self.fetchTokenUseCase as Any }
        localTable["fetchNaverUserInfoUseCase-any FetchNaverUserInfoUseCase"] = { [unowned self] in self.fetchNaverUserInfoUseCase as Any }
        localTable["logoutUseCase-any LogoutUseCase"] = { [unowned self] in self.logoutUseCase as Any }
        localTable["checkIsExistAccessTokenUseCase-any CheckIsExistAccessTokenUseCase"] = { [unowned self] in self.checkIsExistAccessTokenUseCase as Any }
        localTable["remoteLikeDataSource-any RemoteLikeDataSource"] = { [unowned self] in self.remoteLikeDataSource as Any }
        localTable["likeRepository-any LikeRepository"] = { [unowned self] in self.likeRepository as Any }
        localTable["fetchLikeNumOfSongUseCase-any FetchLikeNumOfSongUseCase"] = { [unowned self] in self.fetchLikeNumOfSongUseCase as Any }
        localTable["addLikeSongUseCase-any AddLikeSongUseCase"] = { [unowned self] in self.addLikeSongUseCase as Any }
        localTable["cancelLikeSongUseCase-any CancelLikeSongUseCase"] = { [unowned self] in self.cancelLikeSongUseCase as Any }
        localTable["playlistDetailFactory-any PlaylistDetailFactory"] = { [unowned self] in self.playlistDetailFactory as Any }
        localTable["myPlayListComponent-MyPlayListComponent"] = { [unowned self] in self.myPlayListComponent as Any }
        localTable["remotePlayListDataSource-any RemotePlayListDataSource"] = { [unowned self] in self.remotePlayListDataSource as Any }
        localTable["playListRepository-any PlayListRepository"] = { [unowned self] in self.playListRepository as Any }
        localTable["fetchRecommendPlayListUseCase-any FetchRecommendPlayListUseCase"] = { [unowned self] in self.fetchRecommendPlayListUseCase as Any }
        localTable["fetchPlayListDetailUseCase-any FetchPlayListDetailUseCase"] = { [unowned self] in self.fetchPlayListDetailUseCase as Any }
        localTable["createPlayListUseCase-any CreatePlayListUseCase"] = { [unowned self] in self.createPlayListUseCase as Any }
        localTable["updatePlaylistUseCase-any UpdatePlaylistUseCase"] = { [unowned self] in self.updatePlaylistUseCase as Any }
        localTable["updateTitleAndPrivateUseCase-any UpdateTitleAndPrivateUseCase"] = { [unowned self] in self.updateTitleAndPrivateUseCase as Any }
        localTable["addSongIntoPlayListUseCase-any AddSongIntoPlayListUseCase"] = { [unowned self] in self.addSongIntoPlayListUseCase as Any }
        localTable["removeSongsUseCase-any RemoveSongsUseCase"] = { [unowned self] in self.removeSongsUseCase as Any }
        localTable["uploadPlaylistImageUseCase-any UploadPlaylistImageUseCase"] = { [unowned self] in self.uploadPlaylistImageUseCase as Any }
        localTable["artistComponent-ArtistComponent"] = { [unowned self] in self.artistComponent as Any }
        localTable["remoteArtistDataSource-RemoteArtistDataSourceImpl"] = { [unowned self] in self.remoteArtistDataSource as Any }
        localTable["artistRepository-any ArtistRepository"] = { [unowned self] in self.artistRepository as Any }
        localTable["fetchArtistListUseCase-any FetchArtistListUseCase"] = { [unowned self] in self.fetchArtistListUseCase as Any }
        localTable["artistDetailComponent-ArtistDetailComponent"] = { [unowned self] in self.artistDetailComponent as Any }
        localTable["fetchArtistSongListUseCase-any FetchArtistSongListUseCase"] = { [unowned self] in self.fetchArtistSongListUseCase as Any }
        localTable["artistMusicComponent-ArtistMusicComponent"] = { [unowned self] in self.artistMusicComponent as Any }
        localTable["artistMusicContentComponent-ArtistMusicContentComponent"] = { [unowned self] in self.artistMusicContentComponent as Any }
        localTable["profilePopComponent-ProfilePopComponent"] = { [unowned self] in self.profilePopComponent as Any }
        localTable["favoriteComponent-FavoriteComponent"] = { [unowned self] in self.favoriteComponent as Any }
        localTable["remoteUserDataSource-any RemoteUserDataSource"] = { [unowned self] in self.remoteUserDataSource as Any }
        localTable["userRepository-any UserRepository"] = { [unowned self] in self.userRepository as Any }
        localTable["fetchProfileListUseCase-any FetchProfileListUseCase"] = { [unowned self] in self.fetchProfileListUseCase as Any }
        localTable["setProfileUseCase-any SetProfileUseCase"] = { [unowned self] in self.setProfileUseCase as Any }
        localTable["setUserNameUseCase-any SetUserNameUseCase"] = { [unowned self] in self.setUserNameUseCase as Any }
        localTable["fetchPlayListUseCase-any FetchPlayListUseCase"] = { [unowned self] in self.fetchPlayListUseCase as Any }
        localTable["fetchFavoriteSongsUseCase-any FetchFavoriteSongsUseCase"] = { [unowned self] in self.fetchFavoriteSongsUseCase as Any }
        localTable["editFavoriteSongsOrderUseCase-any EditFavoriteSongsOrderUseCase"] = { [unowned self] in self.editFavoriteSongsOrderUseCase as Any }
        localTable["editPlayListOrderUseCase-any EditPlayListOrderUseCase"] = { [unowned self] in self.editPlayListOrderUseCase as Any }
        localTable["deletePlayListUseCase-any DeletePlayListUseCase"] = { [unowned self] in self.deletePlayListUseCase as Any }
        localTable["deleteFavoriteListUseCase-any DeleteFavoriteListUseCase"] = { [unowned self] in self.deleteFavoriteListUseCase as Any }
        localTable["fetchUserInfoUseCase-any FetchUserInfoUseCase"] = { [unowned self] in self.fetchUserInfoUseCase as Any }
        localTable["withdrawUserInfoUseCase-any WithdrawUserInfoUseCase"] = { [unowned self] in self.withdrawUserInfoUseCase as Any }
        localTable["mainContainerComponent-MainContainerComponent"] = { [unowned self] in self.mainContainerComponent as Any }
        localTable["bottomTabBarComponent-BottomTabBarComponent"] = { [unowned self] in self.bottomTabBarComponent as Any }
        localTable["mainTabBarComponent-MainTabBarComponent"] = { [unowned self] in self.mainTabBarComponent as Any }
        localTable["playerComponent-PlayerComponent"] = { [unowned self] in self.playerComponent as Any }
        localTable["playlistComponent-PlaylistComponent"] = { [unowned self] in self.playlistComponent as Any }
        localTable["openSourceLicenseComponent-OpenSourceLicenseComponent"] = { [unowned self] in self.openSourceLicenseComponent as Any }
        localTable["serviceInfoComponent-ServiceInfoComponent"] = { [unowned self] in self.serviceInfoComponent as Any }
        localTable["permissionComponent-PermissionComponent"] = { [unowned self] in self.permissionComponent as Any }
        localTable["noticePopupComponent-NoticePopupComponent"] = { [unowned self] in self.noticePopupComponent as Any }
        localTable["noticeComponent-NoticeComponent"] = { [unowned self] in self.noticeComponent as Any }
        localTable["noticeDetailComponent-NoticeDetailComponent"] = { [unowned self] in self.noticeDetailComponent as Any }
        localTable["remoteNoticeDataSource-any RemoteNoticeDataSource"] = { [unowned self] in self.remoteNoticeDataSource as Any }
        localTable["noticeRepository-any NoticeRepository"] = { [unowned self] in self.noticeRepository as Any }
        localTable["fetchNoticeUseCase-any FetchNoticeUseCase"] = { [unowned self] in self.fetchNoticeUseCase as Any }
        localTable["fetchNoticeCategoriesUseCase-any FetchNoticeCategoriesUseCase"] = { [unowned self] in self.fetchNoticeCategoriesUseCase as Any }
        localTable["multiPurposePopUpFactory-any MultiPurposePopUpFactory"] = { [unowned self] in self.multiPurposePopUpFactory as Any }
        localTable["textPopUpFactory-any TextPopUpFactory"] = { [unowned self] in self.textPopUpFactory as Any }
        localTable["containSongsFactory-any ContainSongsFactory"] = { [unowned self] in self.containSongsFactory as Any }
        localTable["privacyComponent-PrivacyComponent"] = { [unowned self] in self.privacyComponent as Any }
        localTable["serviceTermsComponent-ServiceTermsComponent"] = { [unowned self] in self.serviceTermsComponent as Any }
        localTable["questionComponent-QuestionComponent"] = { [unowned self] in self.questionComponent as Any }
        localTable["faqComponent-FaqComponent"] = { [unowned self] in self.faqComponent as Any }
        localTable["faqContentComponent-FaqContentComponent"] = { [unowned self] in self.faqContentComponent as Any }
        localTable["remoteFaqDataSource-any RemoteFaqDataSource"] = { [unowned self] in self.remoteFaqDataSource as Any }
        localTable["faqRepository-any FaqRepository"] = { [unowned self] in self.faqRepository as Any }
        localTable["fetchFaqCategoriesUseCase-any FetchFaqCategoriesUseCase"] = { [unowned self] in self.fetchFaqCategoriesUseCase as Any }
        localTable["fetchFaqUseCase-any FetchFaqUseCase"] = { [unowned self] in self.fetchFaqUseCase as Any }
        localTable["remoteAppDataSource-any RemoteAppDataSource"] = { [unowned self] in self.remoteAppDataSource as Any }
        localTable["appRepository-any AppRepository"] = { [unowned self] in self.appRepository as Any }
        localTable["fetchAppCheckUseCase-any FetchAppCheckUseCase"] = { [unowned self] in self.fetchAppCheckUseCase as Any }
        localTable["chartComponent-ChartComponent"] = { [unowned self] in self.chartComponent as Any }
        localTable["chartContentComponent-ChartContentComponent"] = { [unowned self] in self.chartContentComponent as Any }
        localTable["remoteChartDataSource-any RemoteChartDataSource"] = { [unowned self] in self.remoteChartDataSource as Any }
        localTable["chartRepository-any ChartRepository"] = { [unowned self] in self.chartRepository as Any }
        localTable["fetchChartRankingUseCase-any FetchChartRankingUseCase"] = { [unowned self] in self.fetchChartRankingUseCase as Any }
    }
}
extension ArtistComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistDependency.fetchArtistListUseCase] = "fetchArtistListUseCase-any FetchArtistListUseCase"
        keyPathToName[\ArtistDependency.artistDetailComponent] = "artistDetailComponent-ArtistDetailComponent"
    }
}
extension ArtistDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistDetailDependency.artistMusicComponent] = "artistMusicComponent-ArtistMusicComponent"
    }
}
extension ArtistMusicContentComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistMusicContentDependency.fetchArtistSongListUseCase] = "fetchArtistSongListUseCase-any FetchArtistSongListUseCase"
        keyPathToName[\ArtistMusicContentDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
    }
}
extension ArtistMusicComponent: Registration {
    public func registerItems() {
        keyPathToName[\ArtistMusicDependency.artistMusicContentComponent] = "artistMusicContentComponent-ArtistMusicContentComponent"
    }
}
extension PlaylistComponent: Registration {
    public func registerItems() {
        keyPathToName[\PlaylistDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
    }
}
extension PlayerComponent: Registration {
    public func registerItems() {
        keyPathToName[\PlayerDependency.fetchLyricsUseCase] = "fetchLyricsUseCase-any FetchLyricsUseCase"
        keyPathToName[\PlayerDependency.addLikeSongUseCase] = "addLikeSongUseCase-any AddLikeSongUseCase"
        keyPathToName[\PlayerDependency.cancelLikeSongUseCase] = "cancelLikeSongUseCase-any CancelLikeSongUseCase"
        keyPathToName[\PlayerDependency.fetchLikeNumOfSongUseCase] = "fetchLikeNumOfSongUseCase-any FetchLikeNumOfSongUseCase"
        keyPathToName[\PlayerDependency.fetchFavoriteSongsUseCase] = "fetchFavoriteSongsUseCase-any FetchFavoriteSongsUseCase"
        keyPathToName[\PlayerDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\PlayerDependency.playlistComponent] = "playlistComponent-PlaylistComponent"
        keyPathToName[\PlayerDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
    }
}
extension LyricHighlightingComponent: Registration {
    public func registerItems() {
        keyPathToName[\LyricHighlightingDependency.fetchLyricsUseCase] = "fetchLyricsUseCase-any FetchLyricsUseCase"
        keyPathToName[\LyricHighlightingDependency.lyricDecoratingComponent] = "lyricDecoratingComponent-LyricDecoratingComponent"
        keyPathToName[\LyricHighlightingDependency.lyricHighlightingFactory] = "lyricHighlightingFactory-any LyricHighlightingFactory"
    }
}
extension LyricDecoratingComponent: Registration {
    public func registerItems() {

    }
}
extension MainTabBarComponent: Registration {
    public func registerItems() {
        keyPathToName[\MainTabBarDependency.fetchNoticeUseCase] = "fetchNoticeUseCase-any FetchNoticeUseCase"
        keyPathToName[\MainTabBarDependency.homeComponent] = "homeComponent-HomeComponent"
        keyPathToName[\MainTabBarDependency.chartComponent] = "chartComponent-ChartComponent"
        keyPathToName[\MainTabBarDependency.searchFactory] = "searchFactory-any SearchFactory"
        keyPathToName[\MainTabBarDependency.artistComponent] = "artistComponent-ArtistComponent"
        keyPathToName[\MainTabBarDependency.storageFactory] = "storageFactory-any StorageFactory"
        keyPathToName[\MainTabBarDependency.myInfoComponent] = "myInfoComponent-MyInfoComponent"
        keyPathToName[\MainTabBarDependency.noticePopupComponent] = "noticePopupComponent-NoticePopupComponent"
        keyPathToName[\MainTabBarDependency.noticeComponent] = "noticeComponent-NoticeComponent"
        keyPathToName[\MainTabBarDependency.noticeDetailComponent] = "noticeDetailComponent-NoticeDetailComponent"
    }
}
extension BottomTabBarComponent: Registration {
    public func registerItems() {

    }
}
extension MainContainerComponent: Registration {
    public func registerItems() {
        keyPathToName[\MainContainerDependency.bottomTabBarComponent] = "bottomTabBarComponent-BottomTabBarComponent"
        keyPathToName[\MainContainerDependency.mainTabBarComponent] = "mainTabBarComponent-MainTabBarComponent"
        keyPathToName[\MainContainerDependency.playerComponent] = "playerComponent-PlayerComponent"
    }
}
extension NoticePopupComponent: Registration {
    public func registerItems() {

    }
}
extension PlayListDetailComponent: Registration {
    public func registerItems() {
        keyPathToName[\PlayListDetailDependency.fetchPlayListDetailUseCase] = "fetchPlayListDetailUseCase-any FetchPlayListDetailUseCase"
        keyPathToName[\PlayListDetailDependency.updatePlaylistUseCase] = "updatePlaylistUseCase-any UpdatePlaylistUseCase"
        keyPathToName[\PlayListDetailDependency.removeSongsUseCase] = "removeSongsUseCase-any RemoveSongsUseCase"
        keyPathToName[\PlayListDetailDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\PlayListDetailDependency.multiPurposePopUpFactory] = "multiPurposePopUpFactory-any MultiPurposePopUpFactory"
        keyPathToName[\PlayListDetailDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\PlayListDetailDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension ChartComponent: Registration {
    public func registerItems() {
        keyPathToName[\ChartDependency.chartContentComponent] = "chartContentComponent-ChartContentComponent"
    }
}
extension ChartContentComponent: Registration {
    public func registerItems() {
        keyPathToName[\ChartContentDependency.fetchChartRankingUseCase] = "fetchChartRankingUseCase-any FetchChartRankingUseCase"
        keyPathToName[\ChartContentDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
    }
}
extension StorageComponent: Registration {
    public func registerItems() {
        keyPathToName[\StorageDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\StorageDependency.myPlayListComponent] = "myPlayListComponent-MyPlayListComponent"
        keyPathToName[\StorageDependency.multiPurposePopUpFactory] = "multiPurposePopUpFactory-any MultiPurposePopUpFactory"
        keyPathToName[\StorageDependency.favoriteComponent] = "favoriteComponent-FavoriteComponent"
        keyPathToName[\StorageDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension MyPlayListComponent: Registration {
    public func registerItems() {
        keyPathToName[\MyPlayListDependency.multiPurposePopUpFactory] = "multiPurposePopUpFactory-any MultiPurposePopUpFactory"
        keyPathToName[\MyPlayListDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
        keyPathToName[\MyPlayListDependency.fetchPlayListUseCase] = "fetchPlayListUseCase-any FetchPlayListUseCase"
        keyPathToName[\MyPlayListDependency.editPlayListOrderUseCase] = "editPlayListOrderUseCase-any EditPlayListOrderUseCase"
        keyPathToName[\MyPlayListDependency.deletePlayListUseCase] = "deletePlayListUseCase-any DeletePlayListUseCase"
        keyPathToName[\MyPlayListDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\MyPlayListDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
        keyPathToName[\MyPlayListDependency.signInFactory] = "signInFactory-any SignInFactory"
    }
}
extension FavoriteComponent: Registration {
    public func registerItems() {
        keyPathToName[\FavoriteDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
        keyPathToName[\FavoriteDependency.fetchFavoriteSongsUseCase] = "fetchFavoriteSongsUseCase-any FetchFavoriteSongsUseCase"
        keyPathToName[\FavoriteDependency.editFavoriteSongsOrderUseCase] = "editFavoriteSongsOrderUseCase-any EditFavoriteSongsOrderUseCase"
        keyPathToName[\FavoriteDependency.deleteFavoriteListUseCase] = "deleteFavoriteListUseCase-any DeleteFavoriteListUseCase"
        keyPathToName[\FavoriteDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\FavoriteDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
        keyPathToName[\FavoriteDependency.signInFactory] = "signInFactory-any SignInFactory"
    }
}
extension ProfilePopComponent: Registration {
    public func registerItems() {
        keyPathToName[\ProfilePopDependency.fetchProfileListUseCase] = "fetchProfileListUseCase-any FetchProfileListUseCase"
        keyPathToName[\ProfilePopDependency.setProfileUseCase] = "setProfileUseCase-any SetProfileUseCase"
        keyPathToName[\ProfilePopDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
    }
}
extension RootComponent: Registration {
    public func registerItems() {
        keyPathToName[\RootDependency.mainContainerComponent] = "mainContainerComponent-MainContainerComponent"
        keyPathToName[\RootDependency.permissionComponent] = "permissionComponent-PermissionComponent"
        keyPathToName[\RootDependency.fetchUserInfoUseCase] = "fetchUserInfoUseCase-any FetchUserInfoUseCase"
        keyPathToName[\RootDependency.fetchAppCheckUseCase] = "fetchAppCheckUseCase-any FetchAppCheckUseCase"
        keyPathToName[\RootDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\RootDependency.checkIsExistAccessTokenUseCase] = "checkIsExistAccessTokenUseCase-any CheckIsExistAccessTokenUseCase"
        keyPathToName[\RootDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension PermissionComponent: Registration {
    public func registerItems() {

    }
}
extension SignInComponent: Registration {
    public func registerItems() {
        keyPathToName[\SignInDependency.fetchTokenUseCase] = "fetchTokenUseCase-any FetchTokenUseCase"
        keyPathToName[\SignInDependency.fetchNaverUserInfoUseCase] = "fetchNaverUserInfoUseCase-any FetchNaverUserInfoUseCase"
        keyPathToName[\SignInDependency.fetchUserInfoUseCase] = "fetchUserInfoUseCase-any FetchUserInfoUseCase"
    }
}
extension NewSongsComponent: Registration {
    public func registerItems() {
        keyPathToName[\NewSongsDependency.newSongsContentComponent] = "newSongsContentComponent-NewSongsContentComponent"
    }
}
extension HomeComponent: Registration {
    public func registerItems() {
        keyPathToName[\HomeDependency.fetchChartRankingUseCase] = "fetchChartRankingUseCase-any FetchChartRankingUseCase"
        keyPathToName[\HomeDependency.fetchNewSongsUseCase] = "fetchNewSongsUseCase-any FetchNewSongsUseCase"
        keyPathToName[\HomeDependency.fetchRecommendPlayListUseCase] = "fetchRecommendPlayListUseCase-any FetchRecommendPlayListUseCase"
        keyPathToName[\HomeDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
        keyPathToName[\HomeDependency.newSongsComponent] = "newSongsComponent-NewSongsComponent"
    }
}
extension NewSongsContentComponent: Registration {
    public func registerItems() {
        keyPathToName[\NewSongsContentDependency.fetchNewSongsUseCase] = "fetchNewSongsUseCase-any FetchNewSongsUseCase"
        keyPathToName[\NewSongsContentDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
    }
}
extension AfterSearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\AfterSearchDependency.songSearchResultFactory] = "songSearchResultFactory-any SongSearchResultFactory"
        keyPathToName[\AfterSearchDependency.containSongsFactory] = "containSongsFactory-any ContainSongsFactory"
    }
}
extension SongSearchResultComponent: Registration {
    public func registerItems() {

    }
}
extension SearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\SearchDependency.beforeSearchComponent] = "beforeSearchComponent-BeforeSearchComponent"
        keyPathToName[\SearchDependency.afterSearchComponent] = "afterSearchComponent-AfterSearchComponent"
        keyPathToName[\SearchDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension BeforeSearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\BeforeSearchDependency.playlistDetailFactory] = "playlistDetailFactory-any PlaylistDetailFactory"
        keyPathToName[\BeforeSearchDependency.fetchRecommendPlayListUseCase] = "fetchRecommendPlayListUseCase-any FetchRecommendPlayListUseCase"
        keyPathToName[\BeforeSearchDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension ContainSongsComponent: Registration {
    public func registerItems() {
        keyPathToName[\ContainSongsDependency.multiPurposePopUpFactory] = "multiPurposePopUpFactory-any MultiPurposePopUpFactory"
        keyPathToName[\ContainSongsDependency.fetchPlayListUseCase] = "fetchPlayListUseCase-any FetchPlayListUseCase"
        keyPathToName[\ContainSongsDependency.addSongIntoPlayListUseCase] = "addSongIntoPlayListUseCase-any AddSongIntoPlayListUseCase"
        keyPathToName[\ContainSongsDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
    }
}
extension MultiPurposePopUpComponent: Registration {
    public func registerItems() {
        keyPathToName[\MultiPurposePopUpDependency.createPlayListUseCase] = "createPlayListUseCase-any CreatePlayListUseCase"
        keyPathToName[\MultiPurposePopUpDependency.setUserNameUseCase] = "setUserNameUseCase-any SetUserNameUseCase"
        keyPathToName[\MultiPurposePopUpDependency.updateTitleAndPrivateUseCase] = "updateTitleAndPrivateUseCase-any UpdateTitleAndPrivateUseCase"
        keyPathToName[\MultiPurposePopUpDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
    }
}
extension TextPopUpComponent: Registration {
    public func registerItems() {

    }
}
extension ServiceTermsComponent: Registration {
    public func registerItems() {

    }
}
extension PrivacyComponent: Registration {
    public func registerItems() {

    }
}
extension ServiceInfoComponent: Registration {
    public func registerItems() {
        keyPathToName[\ServiceInfoDependency.openSourceLicenseComponent] = "openSourceLicenseComponent-OpenSourceLicenseComponent"
        keyPathToName[\ServiceInfoDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension FaqComponent: Registration {
    public func registerItems() {
        keyPathToName[\FaqDependency.faqContentComponent] = "faqContentComponent-FaqContentComponent"
        keyPathToName[\FaqDependency.fetchFaqCategoriesUseCase] = "fetchFaqCategoriesUseCase-any FetchFaqCategoriesUseCase"
        keyPathToName[\FaqDependency.fetchFaqUseCase] = "fetchFaqUseCase-any FetchFaqUseCase"
    }
}
extension QuestionComponent: Registration {
    public func registerItems() {
        keyPathToName[\QuestionDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension MyInfoComponent: Registration {
    public func registerItems() {
        keyPathToName[\MyInfoDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\MyInfoDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
        keyPathToName[\MyInfoDependency.faqComponent] = "faqComponent-FaqComponent"
        keyPathToName[\MyInfoDependency.noticeComponent] = "noticeComponent-NoticeComponent"
        keyPathToName[\MyInfoDependency.questionComponent] = "questionComponent-QuestionComponent"
        keyPathToName[\MyInfoDependency.teamInfoComponent] = "teamInfoComponent-TeamInfoComponent"
        keyPathToName[\MyInfoDependency.settingComponent] = "settingComponent-SettingComponent"
    }
}
extension SettingComponent: Registration {
    public func registerItems() {
        keyPathToName[\SettingDependency.withdrawUserInfoUseCase] = "withdrawUserInfoUseCase-any WithdrawUserInfoUseCase"
        keyPathToName[\SettingDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\SettingDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
        keyPathToName[\SettingDependency.signInFactory] = "signInFactory-any SignInFactory"
        keyPathToName[\SettingDependency.appPushSettingComponent] = "appPushSettingComponent-AppPushSettingComponent"
        keyPathToName[\SettingDependency.serviceTermsComponent] = "serviceTermsComponent-ServiceTermsComponent"
        keyPathToName[\SettingDependency.privacyComponent] = "privacyComponent-PrivacyComponent"
        keyPathToName[\SettingDependency.openSourceLicenseComponent] = "openSourceLicenseComponent-OpenSourceLicenseComponent"
    }
}
extension RequestComponent: Registration {
    public func registerItems() {
        keyPathToName[\RequestDependency.withdrawUserInfoUseCase] = "withdrawUserInfoUseCase-any WithdrawUserInfoUseCase"
        keyPathToName[\RequestDependency.logoutUseCase] = "logoutUseCase-any LogoutUseCase"
        keyPathToName[\RequestDependency.faqComponent] = "faqComponent-FaqComponent"
        keyPathToName[\RequestDependency.questionComponent] = "questionComponent-QuestionComponent"
        keyPathToName[\RequestDependency.noticeComponent] = "noticeComponent-NoticeComponent"
        keyPathToName[\RequestDependency.serviceInfoComponent] = "serviceInfoComponent-ServiceInfoComponent"
        keyPathToName[\RequestDependency.textPopUpFactory] = "textPopUpFactory-any TextPopUpFactory"
    }
}
extension AppPushSettingComponent: Registration {
    public func registerItems() {

    }
}
extension NoticeDetailComponent: Registration {
    public func registerItems() {

    }
}
extension OpenSourceLicenseComponent: Registration {
    public func registerItems() {

    }
}
extension NoticeComponent: Registration {
    public func registerItems() {
        keyPathToName[\NoticeDependency.fetchNoticeUseCase] = "fetchNoticeUseCase-any FetchNoticeUseCase"
        keyPathToName[\NoticeDependency.noticeDetailComponent] = "noticeDetailComponent-NoticeDetailComponent"
    }
}
extension FaqContentComponent: Registration {
    public func registerItems() {

    }
}
extension TeamInfoComponent: Registration {
    public func registerItems() {

    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->ArtistComponent", factorye0c5444f5894148bdd93f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ArtistDetailComponent", factory35314797fadaf164ece6f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ArtistMusicContentComponent", factory8b6ffa46033e2529b5daf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ArtistMusicComponent", factory382e7f8466df35a3f1d9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PlaylistComponent", factory3a0a6eb1061d8d5a2deff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PlayerComponent", factorybc7f802f601dd5913533f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->LyricHighlightingComponent", factory57ee59e468bef412b173f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->LyricDecoratingComponent", factory5d05db9eb4337d682097e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->MainTabBarComponent", factorye547a52b3fce5887c8c7f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->BottomTabBarComponent", factoryd34fa9e493604a6295bde3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->MainContainerComponent", factory8e19f48d5d573d3ea539f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NoticePopupComponent", factorycd081aacb61d6a707ca7e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->PlayListDetailComponent", factory9e077ee814ce180ea399f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ChartComponent", factoryeac6a4df54bbd391d31bf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ChartContentComponent", factoryc9a137630ce76907f36ff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->StorageComponent", factory2415399d25299b97b98bf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->MyPlayListComponent", factory51a57a92f76af93a9ec2f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->FavoriteComponent", factory8e4acb90bd0d9b48604af47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ProfilePopComponent", factorybd14b11ccce6dac94a24f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->RootComponent", factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PermissionComponent", factoryc1d4d80afbccf86bf1c0e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->SignInComponent", factoryda2925fd76da866a652af47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NewSongsComponent", factory379179b05dd24ff979edf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent", factory67229cdf0f755562b2b1f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NewSongsContentComponent", factorye130e1fbfcbc622a4c38f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AfterSearchComponent", factoryeb2da679e35e2c4fb9a5f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SongSearchResultComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->SearchComponent", factorye3d049458b2ccbbcb3b6f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->BeforeSearchComponent", factory9bb852337d5550979293f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ContainSongsComponent", factory4d4f4455414271fee232f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->MultiPurposePopUpComponent", factorya77269be267fb568bd4ff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->TextPopUpComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->ServiceTermsComponent", factory8014909e2d8dba4e4f20e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->PrivacyComponent", factorye7f5d59533cfdd1614b0e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->ServiceInfoComponent", factory3afd170b9974b0dbd863f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->FaqComponent", factory4e13cc6545633ffc2ed5f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->QuestionComponent", factoryedad1813a36115eec11ef47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->MyInfoComponent", factoryec2cede3edc2a626b35df47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SettingComponent", factoryee0bbc0b920a7007e1a9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->RequestComponent", factory13954fb3ec537bab80bcf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AppPushSettingComponent", factory0fbf44459a0855a29e8be3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->NoticeDetailComponent", factory3db143c2f80d621d5a7fe3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->OpenSourceLicenseComponent", factoryd505894818021731340ae3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->NoticeComponent", factoryaf8e5665e5b9217918f5f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->FaqContentComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->TeamInfoComponent", factorybe60e92b5190e00abf41e3b0c44298fc1c149afb)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
