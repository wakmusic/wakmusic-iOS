import Foundation
import ChartDomainInterface
import Utility

public struct SingleChartRankingResponseDTO: Decodable, Equatable {
    public let id, title, artist, remix, reaction: String
    public let date, start, end: Int
    public let monthly, weekly, daily, hourly, total: SingleChartRankingResponseDTO.ChartInfo?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id = "songId"
        case title, artist, remix, reaction, date, start, end
        case monthly, weekly, daily, hourly, total
    }
}

public extension SingleChartRankingResponseDTO {
    struct ChartInfo: Codable {
        public let views, last: Int
        public let increase: Int?
    }
}

public extension SingleChartRankingResponseDTO {
    func toDomain(type: ChartDateType) -> ChartRankingEntity {
        var views: Int = 0
        var last: Int = 0
        var increase: Int = 0
        switch type {
        case .monthly:
            views = monthly?.views ?? 0
            last = monthly?.last ?? 0
            increase = monthly?.increase ?? 0
        case .weekly:
            views = weekly?.views ?? 0
            last = weekly?.last ?? 0
            increase = weekly?.increase ?? 0
        case .daily:
            views = daily?.views ?? 0
            last = daily?.last ?? 0
            increase = daily?.increase ?? 0
        case .hourly:
            views = hourly?.views ?? 0
            last = hourly?.last ?? 0
            increase = hourly?.increase ?? 0
        case .total:
            views = total?.views ?? 0
            last = total?.last ?? 0
            increase = total?.increase ?? 0
        }

        return ChartRankingEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: views,
            last: last,
            increase: increase,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
