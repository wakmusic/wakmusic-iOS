import LogManager

enum FAQAnalyticsLog: AnalyticsLogType {
    case selectFaqCategory(category: String)
    case clickFaqItem(title: String)
}
