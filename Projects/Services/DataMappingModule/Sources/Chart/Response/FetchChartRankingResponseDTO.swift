import Foundation

public struct SingleChartRankingResponseDTO: Decodable {
    public let id, title, artist, remix: String
    public let reaction: String
    public let date, views, last: Int
}
