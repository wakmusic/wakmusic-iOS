import LogManager

enum LyricHighlightingAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)
    case clickLyricHighlightingCompleteButton(id: String)
    case clickLyricDecoratingCompleteButton(type: String, id: String, bg: String)
}
