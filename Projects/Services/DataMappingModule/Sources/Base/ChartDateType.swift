import Foundation

public enum ChartDateType: String, Codable {
    case monthly
    case weekly
    case daily
    case hourly
    case total

    public var display: String {
        switch self {
        case .monthly:
            return "월간순"
        case .weekly:
            return "주간순"
        case .daily:
            return "일간순"
        case .hourly:
            return "시간순"
        case .total:
            return "누적순"
        }
    }
}
