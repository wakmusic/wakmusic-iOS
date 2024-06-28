import LogManager

enum ArtistAnalyticsLog: AnalyticsLogType {
    case clickArtistItem(artist: String)
    case clickArtistDescription(page: String, artist: String)
    case clickArtistPlayButton(type: String, artist: String)
    case clickArtistTabbarTab(tab: String, artist: String)
    case selectMusicItem(id: String, location: String)
    case deselectMusicItem(id: String, location: String)
}
