import ChartDomainInterface
import Foundation
import Utility

public struct SingleChartRankingResponseDTO: Decodable {
    let updatedAt: Double
    let songs: [SingleChartRankingResponseDTO.Songs]
}

public extension SingleChartRankingResponseDTO {
    struct Songs: Decodable, Equatable {
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
}

public extension SingleChartRankingResponseDTO {
    func toDomain(type: ChartDateType) -> ChartEntity {
        return ChartEntity(
            updatedAt: Date(timeIntervalSince1970: updatedAt / 1000).changeDateFormatForChart() + " 업데이트",
            songs: songs.map {
                return ChartRankingEntity(
                    id: $0.songID,
                    title: $0.title,
                    artist: $0.artists.joined(separator: ", "),
                    views: $0.views,
                    last: $0.last ?? 0,
                    increase: $0.increase,
                    date: $0.date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
                )
            }
        )
    }
}
