import LogManager

enum ArtistAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)
    case clickArtistItem(artist: String)
    case clickArtistDescriptionButton(artist: String)
    case clickArtistSubscriptionButton(artist: String)
    case clickArtistPlayButton(type: String, artist: String)
    case clickArtistTabbarTab(tab: String, artist: String)
}
