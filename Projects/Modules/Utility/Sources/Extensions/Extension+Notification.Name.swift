import Foundation

public extension Notification.Name {
    static let playListRefresh = Notification.Name("playListRefresh")
    static let likeListRefresh = Notification.Name("likeListRefresh")
    static let playListNameRefresh = Notification.Name("playListNameRefresh")
    static let statusBarEnterDarkBackground = Notification.Name("statusBarEnterDarkBackground")
    static let statusBarEnterLightBackground = Notification.Name("statusBarEnterLightBackground")
    static let showSongCart = Notification.Name("showSongCart")
    static let hideSongCart = Notification.Name("hideSongCart")
    static let movedTab = Notification.Name("movedTab")
    static let movedStorageFavoriteTab = Notification.Name("movedStorageFavoriteTab")
    static let updateCurrentSongLikeState = Notification.Name("updateCurrentSongLikeState")
}
