import Foundation

public extension Notification.Name {
    static let playlistRefresh = Notification.Name("playlistRefresh") // 플레이리스트 목록 갱신(보관함 같은) (노래목록 아님)
    static let specificPlaylistRefresh =  Notification.Name("specificPlaylistRefresh") // 특정 key값을 가진 플레이리스트가 다른 화면에서 업데이트 변경되 었을 때 갱신
    static let likeListRefresh = Notification.Name("likeListRefresh")
    static let statusBarEnterDarkBackground = Notification.Name("statusBarEnterDarkBackground")
    static let statusBarEnterLightBackground = Notification.Name("statusBarEnterLightBackground")
    static let showSongCart = Notification.Name("showSongCart")
    static let hideSongCart = Notification.Name("hideSongCart")
    static let movedTab = Notification.Name("movedTab")
    static let movedStorageFavoriteTab = Notification.Name("movedStorageFavoriteTab")
}
