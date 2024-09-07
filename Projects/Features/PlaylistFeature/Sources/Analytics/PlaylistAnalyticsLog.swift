import LogManager

enum PlaylistAnalyticsLog: AnalyticsLogType {
    case clickLockButton(id: String)
    case clickPlaylistEditButton
    case clickPlaylistShareButton
    case clickPlaylistCameraButton
    case clickPlaylistImageButton(type: String)
    case clickPlaylistPlayButton(type: String, key: String)
    case clickPlaylistSubscriptionButton(key: String)
}
