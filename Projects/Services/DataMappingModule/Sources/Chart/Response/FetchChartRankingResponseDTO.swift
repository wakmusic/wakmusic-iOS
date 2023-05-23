import Foundation

public struct SingleChartRankingResponseDTO: Codable, Equatable {
    public let id, title, artist, remix, reaction: String
    public let date, start, end: Int
    public let increase: Int?
    public let monthly, weekly, daily, hourly, total: SingleChartRankingResponseDTO.ChartInfo?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id = "songId"
        case title, artist, remix, reaction, date, start, end, increase
        case monthly, weekly, daily, hourly, total
    }
}

extension SingleChartRankingResponseDTO{
    public struct ChartInfo: Codable {
        public let views, last: Int
        public let increase: Int?
    }
}
