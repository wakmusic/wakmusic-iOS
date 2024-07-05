import LogManager

enum PlaylistAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)
    case clickLockButton(id: String)
    case clickPlaylistEditButton
    case clickPlaylistShareButton
    case clickPlaylistCameraButton
    case clickPlaylistDefaultImageButton
    case clickPlaylistCustomImageButton
    case clickPlaylistPlaybutton(type: String, key: String)
}
