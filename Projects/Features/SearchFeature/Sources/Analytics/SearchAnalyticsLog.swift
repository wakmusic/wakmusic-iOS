import LogManager

enum SearchAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)

    case clickPlaylistItem(location: String)

    /// 검색 전:
    case clickRecommendPlaylistMore
    case clickLatestWakmuYoutubeVideo

    /// 검색 후:
    case viewSearchResult(keyword: String, category: String, count: Int)
    case selectSearchFilter(option: String)
    case selectSearchSort(option: String, category: String)
}
