import Foundation

public enum ChartDateType: String {
    case hourly
    case daily
    case weekly
    case monthly
    case total

    public var display: String {
        switch self {
        case .hourly:
            return "시간순"
        case .daily:
            return "일간순"
        case .weekly:
            return "주간순"
        case .monthly:
            return "월간순"
        case .total:
            return "누적순"
        }
    }
}
