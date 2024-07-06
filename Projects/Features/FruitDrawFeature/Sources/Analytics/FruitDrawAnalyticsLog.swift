import LogManager

enum FruitDrawAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)
    case clickFruitDrawButton
    case clickFruitItem(id: String)
}
