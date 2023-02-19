import DataMappingModule
import DomainModule
import Utility

public extension FetchChartRankingResponseDTO {
    func toDomain() -> [ChartRankingEntity] {
        list.map { $0.toDomain() }
    }
}

public extension SingleChartRankingResponseDTO {
    
    
    func toDomain() -> ChartRankingEntity {
        ChartRankingEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: views,
            last: last,
            date: date.toWMDateString()
        )
    }
}
