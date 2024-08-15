import LogManager

enum MainTabAnalyticsLog: AnalyticsLogType {
    enum TabbarTab: String, CaseIterable, AnalyticsLogEnumParametable {
        case home
        case search
        case artist
        case storage
        case mypage
    }

    case clickTabbarTab(tab: TabbarTab)
    case clickPlaylistFabButton
}
