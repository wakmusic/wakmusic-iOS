import Foundation

public struct FetchChartRankingResponseDTO: Decodable {
    public let list: [SingleChartRankingResponseDTO]
}

public struct SingleChartRankingResponseDTO: Decodable {
    public let id, title, artist, remix: String
    public let reaction: String
    public let date, views, last: Int
}
