import ChartDomainInterface
import Foundation
import Utility

public struct SingleChartRankingResponseDTO: Decodable, Equatable {
    let songID, title: String
    let artists: [String]
    let increase, views, date: Int
    let last: Int?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.songID == rhs.songID
    }

    enum CodingKeys: String, CodingKey {
        case songID = "videoId"
        case title, artists, views, date
        case last = "previousOrder"
        case increase = "viewsIncrement"
    }
}

public extension SingleChartRankingResponseDTO {
    func toDomain(type: ChartDateType) -> ChartRankingEntity {
        return ChartRankingEntity(
            id: songID,
            title: title,
            artist: artists.joined(separator: ", "),
            views: views,
            last: last ?? 0,
            increase: increase,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
