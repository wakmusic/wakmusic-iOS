import Foundation

public extension Notification.Name {
    static let shouldRefreshPlaylist = Notification.Name("shouldRefreshPlaylist") // 플레이리스트 목록 갱신(보관함 같은) (노래목록 아님)
    static let shouldRefreshLikeList = Notification.Name("shouldRefreshLikeList")
    static let didRemovedSubscriptionPlaylist = Notification.Name("didRemovedSubscriptionPlaylist") // 보관함에서 구독플리 제거
    static let willRefreshUserInfo = Notification.Name("willRefreshUserInfo") // 유저 정보 갱신
    static let willStatusBarEnterDarkBackground = Notification.Name("willStatusBarEnterDarkBackground")
    static let willStatusBarEnterLightBackground = Notification.Name("willStatusBarEnterLightBackground")
    static let shouldHidePlaylistFloatingButton = Notification.Name("shouldHidePlaylistFloatingButton")
    static let shouldShowPlaylistFloatingButton = Notification.Name("shouldShowPlaylistFloatingButton")
    static let shouldMovePlaylistFloatingButton = Notification.Name("shouldMovePlaylistFloatingButton")
}
