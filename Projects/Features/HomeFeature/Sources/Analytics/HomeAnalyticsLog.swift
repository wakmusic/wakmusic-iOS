import LogManager

enum HomeAnalyticsLog: AnalyticsLogType {
    case clickChartTop100MusicsTitleButton
    case clickAllChartTop100MusicsButton
    case clickRecentMusicsTitleButton
    case clickAllRecentMusicsButton
    case clickMusicItem(location: MusicItemLocation, id: String)
    case clickMusicItemPlayButton(location: MusicItemLocation, id: String)
}

enum MusicItemLocation: String, AnalyticsLogEnumParametable {
    case homeTop100 = "home-top100"
    case homeRecent = "home-recent"

    var description: String {
        self.rawValue
    }
}
