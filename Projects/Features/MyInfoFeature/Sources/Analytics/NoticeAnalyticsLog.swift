import LogManager

enum NoticeAnalyticsLog: AnalyticsLogType {
    case clickNoticeItem(id: String, location: String = "notice")
}
