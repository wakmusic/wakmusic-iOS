import ChartDomainInterface
import Foundation
import Utility

public struct SingleChartRankingResponseDTO: Decodable, Equatable {
    let songID, title: String
    let artists: [String]
    let date: Int
    let last, increase, views: Int?

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
            views: views ?? 0,
            last: last ?? 0,
            increase: increase ?? 0,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
