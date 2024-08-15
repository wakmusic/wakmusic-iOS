import LogManager

enum ChartAnalyticsLog: AnalyticsLogType {
    enum ChartType: String, CaseIterable, AnalyticsLogEnumParametable {
        case hourly
        case daily
        case weekly
        case monthly
        case total
    }

    case selectChartType(type: ChartType)
}
