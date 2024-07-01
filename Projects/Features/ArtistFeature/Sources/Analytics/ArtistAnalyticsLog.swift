import LogManager

enum ArtistAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)
    case clickArtistItem(artist: String)
    case clickArtistDescriptionButton(page: String, artist: String)
    case clickArtistSubscriptionButton(artist: String)
    case clickArtistPlayButton(type: String, artist: String)
    case clickArtistTabbarTab(tab: String, artist: String)
    case selectMusicItem(id: String, location: String)
    case deselectMusicItem(id: String, location: String)
}
