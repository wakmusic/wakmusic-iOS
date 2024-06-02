import LogManager

enum HomeAnalyticsLog: AnalyticsLogType {
    case clickChartTop100MusicsTitleButton
    case clickAllChartTop100MusicsButton
    case clickMusicItem(location: MusicItemLocation)
}

enum MusicItemLocation: String, CustomStringConvertible {
    case homeTop100 = "home-top100"
    case homeRecent = "home-recent"

    var description: String {
        self.rawValue
    }
}
