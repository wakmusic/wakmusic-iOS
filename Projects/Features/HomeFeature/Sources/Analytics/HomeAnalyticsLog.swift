import LogManager

enum HomeAnalyticsLog: AnalyticsLogType {
    case clickChartTop100MusicsTitleButton
    case clickAllChartTop100MusicsButton
    case clickRecentMusicsTitleButton
    case clickAllRecentMusicsButton
    case clickMusicItem(location: MusicItemLocation, id: String)
}

enum MusicItemLocation: String, AnalyticsLogEnumParametable {
    case homeTop100 = "home_top100"
    case homeRecent = "home_recent"

    var description: String {
        self.rawValue
    }
}
