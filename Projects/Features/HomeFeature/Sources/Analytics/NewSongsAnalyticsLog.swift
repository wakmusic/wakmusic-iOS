import LogManager

enum NewSongsAnalyticsLog: AnalyticsLogType {
    enum RecentMusicType: String, CaseIterable, AnalyticsLogEnumParametable {
        case all
        case woowakgood
        case isegyeIdol = "isegye_idol"
        case gomem
        case academy
    }

    case selectRecentMusicType(type: RecentMusicType)
}
