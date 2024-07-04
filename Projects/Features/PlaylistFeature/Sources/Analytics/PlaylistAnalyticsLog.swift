import LogManager

enum PlaylistAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)
    case clickLockButton(id: String)
    case clickPlaylistEditButton
    case clickPlaylistShareButton
    case clickPlaylistCameraButton
    case clickPlaylistDefaultImageOption
    case clickPlaylistCustomImageOption
//    case clickArtistItem(artist: String)
//    case clickArtistDescriptionButton(artist: String)
//    case clickArtistSubscriptionButton(artist: String)
//    case clickArtistPlayButton(type: String, artist: String)
//    case clickArtistTabbarTab(tab: String, artist: String)
//    case selectMusicItem(id: String, location: String)
//    case deselectMusicItem(id: String, location: String)
}