import LogManager

enum NoticePopupAnalyticsLog: AnalyticsLogType {
    case clickNoticeItem(id: String, location: String = "notice_popup")
}
